import json
import random
from typing import Dict, List
from dataclasses import dataclass, asdict

TROOP_TYPES_PATH = "Modules/Troops/troop_types.json"

@dataclass
class Troop:
    troop_type: str
    count: int
    level: int = 1
    experience: int = 0
    
    def to_dict(self) -> Dict:
        return asdict(self)
    
    @classmethod
    def from_dict(cls, data: Dict) -> "Troop":
        return cls(**data)

class TroopManager:
    def __init__(self):
        with open(TROOP_TYPES_PATH, "r", encoding="utf-8") as f:
            self.config = json.load(f)
        self.troop_types = self.config["troops"]
        self.combat_config = self.config["combat"]
        self.training_config = self.config["training"]
    
    def get_troop_stats(self, troop_type: str) -> Dict:
        return self.troop_types.get(troop_type, {})
    
    def calculate_training_cost(self, troop_type: str, count: int) -> int:
        stats = self.get_troop_stats(troop_type)
        return stats.get("training_cost", 0) * count
    
    def calculate_training_time(self, troop_type: str, count: int) -> int:
        stats = self.get_troop_stats(troop_type)
        base_time = stats.get("training_time", 30)
        return base_time * (count // self.training_config["batch_size"] + 1)
    
    def calculate_upkeep(self, troops: List[Troop]) -> int:
        total = 0
        for troop in troops:
            stats = self.get_troop_stats(troop.troop_type)
            total += stats.get("upkeep", 1) * troop.count
        return total
    
    def calculate_combat_power(self, troops: List[Troop]) -> int:
        total = 0
        for troop in troops:
            stats = self.get_troop_stats(troop.troop_type)
            attack = stats.get("attack", 0)
            defense = stats.get("defense", 0)
            health = stats.get("health", 100)
            power = (attack + defense + health // 10) * troop.count
            total += power
        return total
    
    def simulate_battle(self, attacker_troops: List[Troop], defender_troops: List[Troop]) -> Dict:
        attacker_power = self.calculate_combat_power(attacker_troops)
        defender_power = self.calculate_combat_power(defender_troops)
        
        total_power = attacker_power + defender_power
        if total_power == 0:
            return {"winner": "draw", "attacker_losses": 0, "defender_losses": 0}
        
        attacker_win_chance = attacker_power / total_power
        attacker_wins = random.random() < attacker_win_chance
        
        if attacker_wins:
            loss_ratio = 0.3 + random.random() * 0.2
            return {
                "winner": "attacker",
                "attacker_losses": int(sum(t.count for t in attacker_troops) * loss_ratio * 0.5),
                "defender_losses": int(sum(t.count for t in defender_troops) * loss_ratio * 1.5)
            }
        else:
            loss_ratio = 0.3 + random.random() * 0.2
            return {
                "winner": "defender",
                "attacker_losses": int(sum(t.count for t in attacker_troops) * loss_ratio * 1.5),
                "defender_losses": int(sum(t.count for t in defender_troops) * loss_ratio * 0.5)
            }

troop_manager = TroopManager()
