import random
import time

class AsteroidEngine:
    # سیارک‌های فعال در حال عبور {ast_id: {type, remaining_resources, expires}}
    ACTIVE_ASTEROIDS = {}

    @staticmethod
    def spawn_asteroid():
        types = {
            "iron": {"gold": 50000, "scraps": 200},
            "gold": {"gold": 250000, "scraps": 50},
            "diamond": {"gold": 100000, "crystals": 20}
        }
        chosen_type = random.choice(list(types.keys()))
        ast_id = f"AST-{int(time.time())}"
        
        AsteroidEngine.ACTIVE_ASTEROIDS[ast_id] = {
            "type": chosen_type,
            "resources": types[chosen_type],
            "hp": 10000,
            "expires": time.time() + 3600 # ۱ ساعت زمان برای استخراج
        }
        return ast_id

    @staticmethod
    def mine_asteroid(player_data, ast_id):
        ast = AsteroidEngine.ACTIVE_ASTEROIDS.get(ast_id)
        if not ast: return False, "Asteroid drifted out of range or was mined dry."

        # قدرت حفاری بازیکن (بر اساس نیروها و لول)
        power = player_data.get("troops", 0) * 2
        ast["hp"] -= power
        
        # حفاری موفق -> بخشی از منابع
        gold_share = int(ast["resources"].get("gold", 0) * (power / 10000))
        player_data["gold"] = player_data.get("gold", 0) + gold_share
        
        if ast["hp"] <= 0:
            del AsteroidEngine.ACTIVE_ASTEROIDS[ast_id]
            
        return True, f"Cosmic Extraction: Acquired {gold_share} Gold from {ast['type']} asteroid."
