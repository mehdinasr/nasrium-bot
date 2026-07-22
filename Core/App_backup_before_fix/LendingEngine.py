import time

class LendingEngine:
    INTEREST_RATE = 0.05 # ۵٪ سود بازپرداخت
    LOAN_DURATION = 259200 # ۷۲ ساعت

    @staticmethod
    def calculate_credit_limit(player_data):
        # اعتبار بر اساس لول ساختمان‌ها (هر لول ۱۰۰۰۰ طلا اعتبار)
        th_lvl = player_data.get("town_hall_lvl", 1)
        return th_lvl * 10000

    @staticmethod
    def issue_loan(player_data, amount):
        limit = LendingEngine.calculate_credit_limit(player_data)
        if amount > limit:
            return False, f"Credit Limit Exceeded. Your maximum is {limit}."
        
        if player_data.get("active_loan", 0) > 0:
            return False, "You already have an outstanding debt to the Empire."

        player_data["gold"] = player_data.get("gold", 0) + amount
        player_data["active_loan"] = amount
        player_data["loan_due_date"] = time.time() + LendingEngine.LOAN_DURATION
        
        return True, f"Imperial Credit Issued: {amount} Gold added to your treasury."

    @staticmethod
    def repay_loan(player_data):
        loan_amt = player_data.get("active_loan", 0)
        if loan_amt <= 0: return False, "No active debts detected."

        total_repayment = int(loan_amt * (1 + LendingEngine.INTEREST_RATE))
        if player_data.get("gold", 0) < total_repayment:
            return False, f"Insufficient Gold for repayment. Need {total_repayment}."

        player_data["gold"] -= total_repayment
        player_data["active_loan"] = 0
        player_data["loan_due_date"] = 0
        
        return True, "Debt Cleared. Your credit score has been restored."
