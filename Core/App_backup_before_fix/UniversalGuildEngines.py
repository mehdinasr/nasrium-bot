class GalacticGuilds:
    """ID_1102: مدیریت اتحادیه های صنفی بین لژیونی."""
    GUILDS = ["MINERS_GUILD", "WARRIORS_GUILD", "TRADERS_GUILD"]

class DeepSpaceAuction:
    """ID_1103: حراجی آیتم های افسانه ای در اعماق فضا."""
    @staticmethod
    def get_next_auction():
        return {"item": "NEBULA_STAR_CORE", "min_bid": 10000}

class TaxRebateSystem:
    """ID_1104: بازگشت بخشی از مالیات به کاربران با Honor بالا."""
    @staticmethod
    def calculate_rebate(honor_score, total_tax_paid):
        if honor_score > 1000: return total_tax_paid * 0.15
        return 0
