import json
from typing import Dict, List, Optional
from dataclasses import dataclass, field, asdict

HERO_TYPES_PATH = "Modules/Heroes/hero_types.json"

@dataclass
class Hero:
    hero_id: str
    hero_class: str
    name: str
    level: int = 1
    experience: int = 0
    skills_unlocked: List[str] = field(default_factory=list)
    equipment: Dict[str, Optional[Dict]] = field(default_factory=dict)
    
    def to_dict(self) -> Dict:
        return asdict(self)
    
    @classmethod
    def from_dict(cls, data: Dict) -> "Hero":
        return cls(**data)

class HeroManager:
    def __init__(self):
        with open(HERO_TYPES_PATH, "r", encoding="utf-8") as f:
            self.config = json.load(f)
        self.hero_classes = self.config["hero_classes"]
        self.skills = self.config["skills"]
        self.leveling = self.config["leveling"]
        self.equipment = self.config["equipment"]
    
    def get_class_stats(self, hero_class: str) -> Dict:
        return self.hero_classes.get(hero_class, {})
    
    def calculate_stats(self, hero: Hero) -> Dict:
        base = self.get_class_stats(hero.hero_class)
        growth = self.leveling["stat_growth_per_level"].get(hero.hero_class, {})
        
        stats = {
            "attack": base.get("base_attack", 10) + growth.get("attack", 1) * (hero.level - 1),
            "defense": base.get("base_defense", 10) + growth.get("defense", 1) * (hero.level - 1),
            "health": base.get("base_health", 100) + growth.get("health", 10) * (hero.level - 1),
            "speed": base.get("base_speed", 5) + growth.get("speed", 1) * (hero.level - 1),
            "max_health": base.get("base_health", 100) + growth.get("health", 10) * (hero.level - 1)
        }
        
        for slot, item in hero.equipment.items():
            if item:
                rarity_mult = self.equipment["rarities"].get(item.get("rarity", "common"), {}).get("multiplier", 1.0)
                for stat, value in item.get("stats", {}).items():
                    stats[stat] = stats.get(stat, 0) + int(value * rarity_mult)
        
        return stats
    
    def xp_to_next_level(self, current_level: int) -> int:
        base = self.leveling["base_xp_per_level"]
        return int(base * (current_level ** 1.5))
    
    def add_experience(self, hero: Hero, xp: int) -> Dict:
        hero.experience += xp
        result = {"leveled_up": False, "new_level": hero.level, "skills_unlocked": []}
        
        while hero.experience >= self.xp_to_next_level(hero.level) and hero.level < self.leveling["max_level"]:
            hero.experience -= self.xp_to_next_level(hero.level)
            hero.level += 1
            result["leveled_up"] = True
            result["new_level"] = hero.level
            
            for skill in self.skills.get(hero.hero_class, []):
                if skill["unlock_level"] == hero.level and skill["id"] not in hero.skills_unlocked:
                    hero.skills_unlocked.append(skill["id"])
                    result["skills_unlocked"].append(skill["id"])
        
        return result
    
    def get_available_skills(self, hero: Hero) -> List[Dict]:
        available = []
        for skill in self.skills.get(hero.hero_class, []):
            if skill["id"] in hero.skills_unlocked:
                available.append(skill)
        return available
    
    def calculate_power(self, hero: Hero) -> int:
        stats = self.calculate_stats(hero)
        return stats["attack"] + stats["defense"] + stats["health"] // 10 + stats["speed"] * 2

hero_manager = HeroManager()
