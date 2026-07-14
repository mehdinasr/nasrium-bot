class RefineryEngine:
    # تعریف نرخ های تبدیل پالایشگاه
    RECIPES = {
        "energy": {"name": "Energy Cell", "gold_cost": 5000, "reward_val": 20, "target": "energy"},
        "shield": {"name": "Shield Fragment", "gold_cost": 20000, "reward_val": 7200, "target": "shield"} # 7200 sec = 2h
    }

    @staticmethod
    def refine_resource(player_data, recipe_id):
        recipe = RefineryEngine.RECIPES.get(recipe_id)
        if not recipe: return False, "Invalid recipe."

        if player_data.get("gold", 0) < recipe["gold_cost"]:
            return False, "Insufficient Gold for refinement."

        # کسر هزینه
        player_data["gold"] -= recipe["gold_cost"]

        # اعمال پاداش
        if recipe["target"] == "energy":
            player_data["energy"] = min(100, player_data.get("energy", 100) + recipe["reward_val"])
        elif recipe["target"] == "shield":
            import time
            current_shield = max(time.time(), player_data.get("shield_until", 0))
            player_data["shield_until"] = current_shield + recipe["reward_val"]

        return True, f"Refinement Complete: {recipe['name']} produced."
