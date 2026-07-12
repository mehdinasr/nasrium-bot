import json
import os
from typing import Dict, Any

BALANCE_PATH = os.path.join(os.path.dirname(__file__), "balance.json")

class BalanceConfig:
    _instance = None
    _data = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._load()
        return cls._instance
    
    @classmethod
    def _load(cls):
        with open(BALANCE_PATH, "r", encoding="utf-8") as f:
            cls._data = json.load(f)
    
    @classmethod
    def reload(cls):
        cls._load()
        return cls._data
    
    def get(self, *keys: str) -> Any:
        result = self._data
        for key in keys:
            result = result[key]
        return result
    
    def get_economy(self) -> Dict:
        return self._data["economy"]
    
    def get_building(self, building_name: str) -> Dict:
        return self._data["buildings"][building_name]
    
    def get_troops(self) -> Dict:
        return self._data["troops"]
    
    def collect_amount(self, level: int) -> int:
        base = self._data["economy"]["collect"]["base_amount"]
        mult = self._data["economy"]["collect"]["level_multiplier"]
        max_amt = self._data["economy"]["collect"]["max_amount"]
        amount = int(base * (mult ** (level - 1)))
        return min(amount, max_amt)
    
    def attack_reward(self, attacker_level: int, victim_balance: int) -> int:
        base = self._data["economy"]["attack"]["reward_base"]
        mult = self._data["economy"]["attack"]["reward_multiplier"]
        return int(base * (mult ** (attacker_level - 1)))
    
    def upgrade_cost(self, building: str, current_level: int) -> int:
        costs = self._data["buildings"][building]["upgrade_costs"]
        if current_level < len(costs):
            return costs[current_level]
        return costs[-1] * 2

balance = BalanceConfig()
