import random
import time

class SoulBoundTokens:
    """CMD_957: توکن‌های روح‌بند (SBT) - افتخارات غیرقابل انتقال."""
    @staticmethod
    def award_sbt(player_data, achievement_id):
        sbt_list = player_data.get("soul_bound_tokens", [])
        if achievement_id not in sbt_list:
            sbt_list.append(achievement_id)
            player_data["soul_bound_tokens"] = sbt_list
            return True, f"Soul-Bound Token [{achievement_id}] fused to your core."
        return False, "Token already exists."

class TheOracle:
    """CMD_958: اوراکل نصریوم - پیش‌بینی رویدادهای بازار و جنگ."""
    @staticmethod
    def get_prediction():
        predictions = [
            "Market Volatility: IXP Value increase in 2 hours.",
            "Legion Movement: Shadow Fleet detected near Sector 4.",
            "Resource Surge: Quantum Energy regen will double at Midnight."
        ]
        return random.choice(predictions)

class ImperialMintV2:
    """CMD_959: نهایی‌سازی استاندارد NSM (Nasrium Sovereign Money)."""
    TOTAL_SUPPLY_NSM = 1000000000 # ۱ میلیارد سقف کل
    BURNED_NSM = 0

    @staticmethod
    def get_circulating_supply():
        return ImperialMintV2.TOTAL_SUPPLY_NSM - ImperialMintV2.BURNED_NSM
