class InterPlanetaryLogistics:
    """ID_1081: مدیریت ناوگان باربری حجیم بین سیارات."""
    @staticmethod
    def get_freight_capacity(ship_level):
        return ship_level * 500000

class ExoticRefining:
    """ID_1082: تصفیه مواد نایاب برای تولید سوخت وارپ."""
    @staticmethod
    def process_matter(raw_units):
        return raw_units * 0.1 # بازدهی 10 درصد

class TradeGuild:
    """ID_1083: صدور مجوز فعالیت اقتصادی در بازارهای بین لژیونی."""
    @staticmethod
    def issue_license(u_id, credit_score):
        if credit_score > 700: return True, "Guild License Issued."
        return False, "Insufficient Credit Score."
