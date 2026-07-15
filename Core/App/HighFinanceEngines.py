class NasriumIndex:
    """ID_1046: رهگیری ارزش لحظه ای NSM."""
    @staticmethod
    def get_current_price():
        import random
        return 1.25 + (random.random() * 0.5) # قیمت شبیه سازی شده

class LiquidityInjection:
    """ID_1047: مکانیسم سوزاندن IXP برای تقویت ارزش NSM."""
    @staticmethod
    def inject(amount_ixp):
        return f"Liquidity enhanced. {amount_ixp} IXP incinerated for NSM stability."

class CreditScoring:
    """ID_1048: تعیین سطح اعتبار شهروندان بر اساس رفتار پاک."""
    @staticmethod
    def calculate_score(player_data):
        score = player_data.get("honor_score", 0) * 1.5
        return min(1000, score)
