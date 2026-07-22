class ColdWarEngine:
    # لیست تحریم‌های فعال {target_id: {by_fed, type, expiry}}
    ACTIVE_SANCTIONS = {}

    @staticmethod
    def impose_sanction(fed_data, target_id, sanction_type):
        # هزینه اعمال تحریم: 200,000 طلا از خزانه فدراسیون
        if fed_data.get("reserve_gold", 0) < 200000:
            return False, "Insufficient Federation Reserves."

        import time
        sanction_id = f"SANC-{int(time.time())}"
        ColdWarEngine.ACTIVE_SANCTIONS[target_id] = {
            "origin": fed_data.get("name"),
            "type": sanction_type, # e.g., "TRADE_RESTRICTION", "RESOURCE_DAMPING"
            "expiry": time.time() + 86400 # ۲۴ ساعت اعتبار
        }
        
        fed_data["reserve_gold"] -= 200000
        return True, f"Sanction {sanction_id} imposed on {target_id}."

    @staticmethod
    def get_sanction_effect(player_data):
        # بررسی اینکه آیا بازیکن تحت تحریم است؟
        u_id = player_data["user_id"]
        syn_name = player_data.get("syndicate", "None")
        
        if u_id in ColdWarEngine.ACTIVE_SANCTIONS or syn_name in ColdWarEngine.ACTIVE_SANCTIONS:
            return 0.75 # ۲۵٪ کاهش راندمان
        return 1.0
