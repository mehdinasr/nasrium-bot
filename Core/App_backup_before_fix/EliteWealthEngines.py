class EliteMarket:
    """ID_1013: بازار محصولات استراتژیک فقط برای رتبه‌های Sovereign Patron."""
    ELITE_ITEMS = {"system_core_access": 500, "legion_shield_v2": 1000} # قیمت به NSM

class WarCall:
    """ID_1014: سیستم فراخوان لژیون‌ها برای نبرد قمر NSM."""
    @staticmethod
    def initiate_mobilization():
        return "ALL LEGIONS MIGRATING TO ORBITAL GRID."

class PensionSystem:
    """ID_1015: توزیع ۱۰٪ از درآمدهای TON تمدن بین شهروندان فعال."""
    @staticmethod
    def calculate_pension(player_data, total_revenue):
        share = (player_data.get("honor_score", 0) / 1000000) * (total_revenue * 0.1)
        return share
