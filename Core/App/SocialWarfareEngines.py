class MercenaryGuild:
    """ID_1117: سیستم استخدام بازیکنان آزاد برای دفاع از لژیون ها."""
    CONTRACTS = []
    @staticmethod
    def post_contract(l_name, reward):
        MercenaryGuild.CONTRACTS.append({"legion": l_name, "reward": reward})

class TacticalSatelliteGrid:
    """ID_1118: بوف های نظامی برای اعضای فدراسیون ها در آرنا."""
    @staticmethod
    def get_tactical_bonus(sat_count):
        return sat_count * 0.02

class VeteranSystem:
    """ID_1119: شناسایی کاربران قدیمی برای اعطای بوف های پایداری."""
    @staticmethod
    def is_veteran(join_date_timestamp):
        # بررسی اگر کاربر بیش از 30 روز عضو باشد
        import time
        return (time.time() - join_date_timestamp) > 2592000
