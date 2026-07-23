class SimpleBuildingEngine:
    UPGRADE_BASE_COST = {
        "gold_mine": 500,
        "gem_drill": 800
    }
    UPGRADE_COST_MULTIPLIER = 1.6

    @staticmethod
    def get_upgrade_cost(building_type, current_level):
        base = SimpleBuildingEngine.UPGRADE_BASE_COST.get(building_type)
        if base is None:
            return None
        return int(base * (SimpleBuildingEngine.UPGRADE_COST_MULTIPLIER ** current_level))

    @staticmethod
    def attempt_upgrade(building_type, player_data):
        buildings = player_data.get("buildings", {"gold_mine": 0, "gem_drill": 0})
        current_level = buildings.get(building_type, 0)
        cost = SimpleBuildingEngine.get_upgrade_cost(building_type, current_level)
        if cost is None:
            return {"success": False, "message": "Invalid building type"}
        gold = player_data.get("gold", 0)
        if gold < cost:
            return {"success": False, "message": f"Insufficient Gold. {cost} required."}
        return {
            "success": True,
            "cost": cost,
            "new_level": current_level + 1,
            "new_gold": gold - cost
        }
