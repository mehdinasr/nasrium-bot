class BorderEngine:
    # قوانین پیش‌فرض مرزی برای سندیکاها {syn_id: {min_lvl, min_honor, open}}
    SYNDICATE_RULES = {}

    @staticmethod
    def set_rules(syn_id, min_lvl=1, min_honor=0, is_open=True):
        BorderEngine.SYNDICATE_RULES[syn_id] = {
            "min_level": min_lvl,
            "min_honor": min_honor,
            "is_open": is_open
        }
        return True, f"Border rules for {syn_id} updated."

    @staticmethod
    def check_visa(player_data, syn_id):
        rules = BorderEngine.SYNDICATE_RULES.get(syn_id)
        if not rules: return True, "No restrictions in this sector."

        if not rules["is_open"]:
            return False, "This Syndicate's borders are currently sealed."

        if player_data.get("town_hall_lvl", 1) < rules["min_level"]:
            return False, f"Visa Denied: Minimum Level {rules['min_level']} required."

        if player_data.get("honor_score", 0) < rules["min_honor"]:
            return False, f"Visa Denied: Minimum Honor {rules['min_honor']} required."

        return True, "Visa Approved. Welcome to the Syndicate."
