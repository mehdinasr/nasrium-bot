class ConquestEngine:
    """ID_1030: مدیریت رویداد تسلیم نهایی و جذب خراج از سایر بخش ها."""
    EVENT_ACTIVE = True
    TRIBUTE_MULTIPLIER = 5.0 # پنج برابر شدن پاداش های جذب شده

    @staticmethod
    def claim_tribute(player_data):
        if not ConquestEngine.EVENT_ACTIVE:
            return False, "The Great Surrender period has concluded."
        
        # محاسبه خراج بر اساس رتبه و سطح بازیکن
        base_tribute = 50000 # 50k IXP پایه
        total_tribute = base_tribute * player_data.get("level", 1) * ConquestEngine.TRIBUTE_MULTIPLIER
        
        player_data["intel_xp"] += total_tribute
        player_data["conquest_points"] = player_data.get("conquest_points", 0) + 1
        
        return True, f"Surrender accepted. {total_tribute} IXP assimilated from external sectors."
