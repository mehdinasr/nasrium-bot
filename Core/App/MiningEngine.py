import random

class MiningEngine:
    # تعریف اعماق و جوایز
    DEPTHS = {
        "sub": {"name": "Sub-Surface", "energy": 5, "reward_range": (1000, 5000), "crystal_chance": 0.05},
        "core": {"name": "Core-Layer", "energy": 12, "reward_range": (5000, 15000), "crystal_chance": 0.20},
        "abyssal": {"name": "Abyssal-Zone", "energy": 25, "reward_range": (15000, 50000), "crystal_chance": 0.50}
    }

    @staticmethod
    def execute_drill(player_data, depth_id):
        depth = MiningEngine.DEPTHS.get(depth_id)
        if not depth: return False, "Invalid depth coordinates."

        if player_data.get("energy", 0) < depth["energy"]:
            return False, "Insufficient energy for deep core drilling."

        # مصرف انرژی
        player_data["energy"] -= depth["energy"]
        
        # استخراج طلا
        gold_gain = random.randint(*depth["reward_range"])
        player_data["gold"] = player_data.get("gold", 0) + gold_gain
        
        # شانس استخراج بلور اولیه (Primal Crystal)
        crystal_gain = 0
        if random.random() < depth["crystal_chance"]:
            crystal_gain = random.randint(1, 5)
            player_data["primal_crystals"] = player_data.get("primal_crystals", 0) + crystal_gain
        
        msg = f"Drill Complete: +{gold_gain} Gold"
        if crystal_gain > 0: msg += f" and {crystal_gain} Primal Crystals extracted!"
        
        return True, msg
