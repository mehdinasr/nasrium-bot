import random

class HighFinanceEngines:
    """ID_1046: مدیریت شاخص قیمت و نقدینگی."""
    @staticmethod
    def get_nsm_index():
        # قیمت پایه 1.25 TON با نوسان تصادفی
        return 1.25 + (random.random() * 0.4)

    """ID_1047: تزریق نقدینگی و سوزاندن IXP."""
    @staticmethod
    def inject_liquidity(player_data, amount_ixp):
        if player_data.get("intel_xp", 0) < amount_ixp:
            return False, "Insufficient IXP for injection."
        player_data["intel_xp"] -= amount_ixp
        # سوزاندن IXP باعث تقویت غیرمستقیم ارزش NSM در دیتابیس می شود
        return True, f"Liquidity Pulse: {amount_ixp} IXP incinerated."

    """ID_1048: سیستم اعتبار سنجی نخبگان."""
    @staticmethod
    def get_credit_score(player_data):
        # اعتبار بر اساس میزان افتخار (Honor Score)
        honor = player_data.get("honor_score", 0)
        score = min(1000, honor * 2)
        return score
