import time

class ImperialBank:
    """CMD_944: سیستم سپرده‌گذاری و سود بانکی (Staking)."""
    STAKE_RATE = 0.05 # ۵٪ سود روزانه برای سپرده‌های بلندمدت

    @staticmethod
    def stake_ixp(player_data, amount):
        if player_data.get("intel_xp", 0) < amount:
            return False, "Insufficient IXP for staking."
        player_data["intel_xp"] -= amount
        player_data["staked_amount"] = player_data.get("staked_amount", 0) + amount
        player_data["last_stake_time"] = time.time()
        return True, f"{amount} IXP locked in the Imperial Vault. Earning 5% daily."

class CoopFarming:
    """CMD_945: مزارع اشتراکی برای استخراج گروهی."""
    @staticmethod
    def calculate_coop_bonus(members_count):
        # هر عضو اضافی ۲٪ به سرعت استخراج کل گروه اضافه می‌کند
        return 1.0 + (members_count * 0.02)

class HighCourt:
    """CMD_946: سیستم گزارش تخلفات و قضاوت سیستمی."""
    PENDING_CASES = [] # [{"target_id": u_id, "reason": str, "reporter": u_id}]

    @staticmethod
    def file_report(reporter_id, target_id, reason):
        HighCourt.PENDING_CASES.append({
            "target_id": target_id, 
            "reason": reason, 
            "reporter": reporter_id,
            "status": "AWAITING_JUDGMENT"
        })
        return True, "Case filed in the High Court. Sovereigns will review."
