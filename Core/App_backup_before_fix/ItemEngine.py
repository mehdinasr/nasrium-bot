class ItemEngine:
    # تعریف اشیاء مرجع امپراتوری
    ARTIFACTS = {
        "neural_link": {"name": "Neural Link", "boost": "atk", "value": 0.15, "desc": "+15% Attack Power"},
        "titanium_hull": {"name": "Titanium Hull", "boost": "def", "value": 0.20, "desc": "+20% Defense Power"},
        "quantum_drill": {"name": "Quantum Drill", "boost": "gold", "value": 0.25, "desc": "+25% Gold Production"},

        "neural_link_v2": {"name": "Neural Link V2", "boost": "atk", "value": 0.35, "desc": "+35% Attack Power"},
        "titanium_hull_v2": {"name": "Titanium Hull V2", "boost": "def", "value": 0.45, "desc": "+45% Defense Power"},
        "quantum_drill_v2": {"name": "Quantum Drill V2", "boost": "gold", "value": 0.55, "desc": "+55% Gold Production"}
    
    }

    @staticmethod
    def calculate_boosted_value(base_val, player_data, boost_type):
        inventory = player_data.get("inventory", [])
        total_multiplier = 1.0
        
        for item_id in inventory:
            item = ItemEngine.ARTIFACTS.get(item_id)
            if item and item["boost"] == boost_type:
                total_multiplier += item["value"]
        
        return int(base_val * total_multiplier)
