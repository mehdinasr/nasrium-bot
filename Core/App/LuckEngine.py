import random

class LuckEngine:
    # تعریف جوایز و شانس برنده شدن (جمع اوزان باید 100 باشد)
    REWARDS = [
        {"id": "small_gold", "name": "5,000 Gold", "weight": 50, "type": "gold", "value": 5000},
        {"id": "med_xp", "name": "200 XP", "weight": 30, "type": "xp", "value": 200},
        {"id": "heavy_units", "name": "5 Elite Warriors", "weight": 15, "type": "troops", "value": 5},
        {"id": "rare_artifact", "name": "Neural Link V2", "weight": 5, "type": "item", "value": "neural_link_v2"}
    ]

    @staticmethod
    def decrypt_vault(player_data):
        cost = 200
        if player_data.get("nsm_soft", 0) < cost:
            return False, "Insufficient NSM Soft (Need 200).", None

        # کسر هزینه
        player_data["nsm_soft"] -= cost
        
        # انتخاب جایزه بر اساس وزن
        weights = [r["weight"] for r in LuckEngine.REWARDS]
        reward = random.choices(LuckEngine.REWARDS, weights=weights, k=1)[0]
        
        # اعمال جایزه به بازیکن
        if reward["type"] == "gold":
            player_data["gold"] = player_data.get("gold", 0) + reward["value"]
        elif reward["type"] == "xp":
            from Core.App.ExperienceEngine import ExperienceEngine
            player_data, _ = ExperienceEngine.add_xp(player_data, reward["value"])
        elif reward["type"] == "troops":
            army = player_data.get("army", {"scout":0, "warrior":0, "siege":0})
            army["warrior"] += reward["value"]
            player_data["army"] = army
            player_data["troops"] = sum(army.values())
        elif reward["type"] == "item":
            inv = player_data.get("inventory", [])
            inv.append(reward["value"])
            player_data["inventory"] = inv

        return True, f"Decryption Success: {reward['name']}", reward
