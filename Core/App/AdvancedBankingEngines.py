import time

class LendingEngine:
    """CMD_973: سیستم وام‌دهی لژیونی برای افزایش قدرت اعضا."""
    @staticmethod
    def calculate_loan_limit(player_data):
        # سقف وام: ۲۰٪ از کل ثروت استیک شده در بانک
        return player_data.get("staked_amount", 0) * 0.2

    @staticmethod
    def issue_loan(player_data, amount):
        limit = LendingEngine.calculate_loan_limit(player_data)
        if amount > limit:
            return False, f"Loan denied. Your limit is {limit} IXP."
        
        player_data["intel_xp"] += amount
        player_data["debt"] = player_data.get("debt", 0) + (amount * 1.1) # ۱۰٪ کارمزد بازپرداخت
        return True, f"Loan of {amount} IXP issued. Repayment: {amount * 1.1} IXP."

class InsuranceEngine:
    """CMD_974: بیمه امپراتوری برای محافظت در برابر حملات آرنا و رویدادها."""
    @staticmethod
    def buy_insurance(player_data, plan_type):
        costs = {"BASIC": 50000, "ELITE": 200000}
        if player_data.get("intel_xp", 0) < costs.get(plan_type):
            return False, "Insufficient IXP for insurance premium."
        
        player_data["intel_xp"] -= costs[plan_type]
        player_data["insurance_active"] = True
        player_data["insurance_expiry"] = time.time() + 86400 # ۲۴ ساعت اعتبار
        return True, f"{plan_type} Insurance activated for 24 hours."

class VirtualDebitCard:
    """CMD_975: متادیتای کارت اعتباری مجازی نصریوم."""
    @staticmethod
    def generate_card(u_id):
        import hashlib
        card_num = hashlib.sha256(f"CARD-{u_id}".encode()).hexdigest()[:16].upper()
        return {
            "card_number": " ".join([card_num[i:i+4] for i in range(0, 16, 4)]),
            "holder": f"CITIZEN-{u_id[:6]}",
            "expiry": "12/99",
            "status": "PRE-LAUNCH / TON_READY"
        }
