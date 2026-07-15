class GalacticDefenseGrid:
    """ID_1271: سپرهای یونی برای محافظت از متصرفات جدید."""
    @staticmethod
    def activate_grid(sector):
        return f"ION_SHIELD_ACTIVE_IN_{sector}"

class ExoticMatterRefinery:
    """ID_1274: فرآوری مواد نایاب برای ارتقای نهایی دستیار AI."""
    @staticmethod
    def refine(raw_units):
        return raw_units * 0.25 # بازدهی 25 درصد
