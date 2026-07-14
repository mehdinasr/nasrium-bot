import time
import random

class LogisticsEngine:
    # هزینه سوخت ترابری: 500 طلا ثابت + 2 درصد از حجم محموله
    BASE_FUEL_COST = 500

    @staticmethod
    def start_transport(player_data, target_id, resource_type, amount):
        if player_data.get(resource_type, 0) < amount:
            return False, "Insufficient resources for transport."
        
        fuel_needed = LogisticsEngine.BASE_FUEL_COST + int(amount * 0.02)
        if player_data.get("gold", 0) < fuel_needed:
            return False, f"Insufficient Gold for fuel. Need {fuel_needed}."

        # کسر منابع و سوخت
        player_data[resource_type] -= amount
        player_data["gold"] -= fuel_needed
        
        # ثبت محموله در صف
        transport_id = f"TRP-{int(time.time())}"
        delivery_time = time.time() + 1800 # ۳۰ دقیقه زمان پایه
        
        transport_data = {
            "id": transport_id,
            "target": target_id,
            "type": resource_type,
            "amount": amount,
            "arrival": delivery_time,
            "status": "EN_ROUTE"
        }
        
        active_transports = player_data.get("active_transports", [])
        active_transports.append(transport_data)
        player_data["active_transports"] = active_transports
        
        return True, f"Caravan {transport_id} dispatched. Arrival in 30m."

    @staticmethod
    def check_interception(sector_volatility):
        # ریسک رهگیری بر اساس التهاب بخش (CMD_417)
        return random.randint(1, 100) < (sector_volatility / 5)
