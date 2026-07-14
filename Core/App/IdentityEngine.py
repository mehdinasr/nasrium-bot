import hashlib
import json
import time

class IdentityEngine:
    @staticmethod
    def generate_state_signature(player_data):
        # انتخاب فیلدهای حیاتی برای هش کردن
        core_stats = {
            "u_id": player_data.get("user_id"),
            "lvl": player_data.get("town_hall_level", 1),
            "gold": player_data.get("gold", 0),
            "nsm": player_data.get("nsm_soft", 0),
            "wallet": player_data.get("wallet_address", "none")
        }
        # تولید یک رشته متنی ثابت از داده ها
        stat_string = json.dumps(core_stats, sort_keys=True)
        # تولید هش SHA-256 به عنوان امضای وضعیت
        signature = hashlib.sha256(stat_string.encode()).hexdigest()
        return signature

    @staticmethod
    def get_passport_metadata(player_data):
        signature = IdentityEngine.generate_state_signature(player_data)
        return {
            "name": player_data.get("username", "Unknown Citizen"),
            "rank": "Commander" if player_data.get("town_hall_level", 1) > 5 else "Recruit",
            "issue_date": time.strftime("%Y-%m-%d"),
            "status": "Verified" if player_data.get("wallet_active") else "Unlinked",
            "sig": signature[:16].upper() # نمایش بخشی از امضا برای زیبایی UI
        }
