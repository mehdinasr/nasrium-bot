import random
import time

class RebellionEngine:
    # لیست شورش‌های فعال {sector_id: {threat_lvl, expires}}
    ACTIVE_REBELLIONS = {}

    @staticmethod
    def spawn_rebellion(sector_id):
        # ایجاد یک تهدید جدید در یک بخش
        threat_lvl = random.randint(1, 5)
        RebellionEngine.ACTIVE_REBELLIONS[sector_id] = {
            "name": f"Rogue Cell {random.randint(100,999)}",
            "threat_lvl": threat_lvl,
            "hp": threat_lvl * 5000,
            "max_hp": threat_lvl * 5000,
            "expires": time.time() + 7200 # ۲ ساعت مهلت سرکوب
        }
        return True

    @staticmethod
    def suppress(player_data, sector_id):
        rebel = RebellionEngine.ACTIVE_REBELLIONS.get(sector_id)
        if not rebel: return False, "No active rebellion in this sector."

        # قدرت حمله بازیکن (ترکیب نیروها و لول آکادمی)
        power = player_data.get("troops", 0) * 1.5
        rebel["hp"] -= power
        
        if rebel["hp"] <= 0:
            del RebellionEngine.ACTIVE_REBELLIONS[sector_id]
            # پاداش سرکوب: قطعات اسقاطی نایاب
            player_data["scraps"] = player_data.get("scraps", 0) + (rebel["threat_lvl"] * 50)
            return True, f"Incursion Repressed! Earned {rebel['threat_lvl'] * 50} premium scraps."
        
        return True, f"Assault successful. NPC remaining HP: {int(rebel['hp'])}."
