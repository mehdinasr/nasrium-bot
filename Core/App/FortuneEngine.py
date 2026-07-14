import random
import time

class FortuneEngine:
    # لیست جوایز و وزن احتمالات (جمع وزن‌ها ۱۰۰)
    REWARDS = [
        {"id": "soft_500", "name": "500 NSM", "weight": 40, "type": "nsm_soft", "amt": 500},
        {"id": "energy_10", "name": "10 Energy", "weight": 30, "type": "energy", "amt": 10},
        {"id": "gold_5000", "name": "5,000 Gold", "weight": 20, "type": "gold", "amt": 5000},
        {"id": "titan_serum", "name": "Titan Serum", "weight": 8, "type": "catalyst", "amt": 1},
        {"id": "hard_5", "name": "5 NSM Hard", "weight": 2, "type": "nsm_hard", "amt": 5}
    ]

    @staticmethod
    def spin(player_data):
        # بررسی محدودیت زمانی (هر ۲۴ ساعت یکبار)
        last_spin = player_data.get("last_fortune_spin", 0)
        if time.time() - last_spin < 86400:
            return False, "The Matrix is recalibrating. Come back tomorrow.", None

        # انتخاب جایزه بر اساس وزن
        options = []
        for r in FortuneEngine.REWARDS:
            options.extend([r] * r["weight"])
        
        win = random.choice(options)
        
        # اعمال جایزه به دیتای بازیکن
        if win["type"] == "catalyst":
            inv = player_data.get("consumables", {})
            inv["titan"] = inv.get("titan", 0) + 1
            player_data["consumables"] = inv
        else:
            player_data[win["type"]] = player_data.get(win["type"], 0) + win["amt"]
        
        player_data["last_fortune_spin"] = time.time()
        return True, f"Destiny has spoken: You won {win['name']}!", win
