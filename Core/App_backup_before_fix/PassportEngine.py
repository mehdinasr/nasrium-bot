import hashlib
import time

class PassportEngine:
    @staticmethod
    def generate_soulbound_id(player_data):
        # ترکیب پارامترهای کلیدی برای تولید شناسه منحصربه‌فرد
        u_id = player_data.get("user_id")
        th_lvl = player_data.get("town_hall_level", 1)
        spec = player_data.get("specialization", "none")
        wallet = player_data.get("ton_wallet", "unlinked")
        
        raw_identity = f"{u_id}:{th_lvl}:{spec}:{wallet}:{time.time()}"
        identity_hash = hashlib.sha256(raw_identity.encode()).hexdigest().upper()
        
        return {
            "passport_no": f"NSM-SB-{identity_hash[:12]}",
            "issue_date": time.strftime("%Y-%m-%d"),
            "security_clearance": "LEVEL_" + str(min(5, th_lvl)),
            "digital_signature": identity_hash
        }
