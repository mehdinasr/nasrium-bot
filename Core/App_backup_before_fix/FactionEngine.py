class FactionEngine:
    # تعریف رسته‌ها و بونوس‌های مربوطه
    FACTIONS = {
        "harvester": {"name": "The Harvesters", "bonus": "gold", "value": 1.25, "desc": "+25% Gold Production"},
        "guardian": {"name": "The Guardians", "bonus": "def", "value": 1.25, "desc": "+25% Defense Power"},
        "infiltrator": {"name": "The Infiltrators", "bonus": "spy", "value": 1.25, "desc": "+25% Spy Success Chance"}
    }

    @staticmethod
    def get_player_faction(player_data):
        return player_data.get("faction")

    @staticmethod
    def apply_faction_bonus(player_data, base_value, target_type):
        faction_id = player_data.get("faction")
        if not faction_id: return base_value
        
        faction_info = FactionEngine.FACTIONS.get(faction_id)
        if faction_info and faction_info["bonus"] == target_type:
            return base_value * faction_info["value"]
        return base_value
