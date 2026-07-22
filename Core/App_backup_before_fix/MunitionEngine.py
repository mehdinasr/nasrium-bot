class MunitionEngine:
    # دستورالعمل‌های تولید {id: {name, gold_cost, scrap_cost, time}}
    RECIPES = {
        "orbital_shell": {"name": "Orbital Shell", "gold": 5000, "scraps": 10, "time": 300},
        "emp_slug": {"name": "EMP Slug", "gold": 8000, "scraps": 15, "time": 600},
        "solaris_cell": {"name": "Solaris Cell", "gold": 12000, "scraps": 20, "time": 900}
    }

    @staticmethod
    def start_production(player_data, recipe_id):
        recipe = MunitionEngine.RECIPES.get(recipe_id)
        if not recipe: return False, "Invalid Munition Blueprint."

        if player_data.get("gold", 0) < recipe["gold"] or player_data.get("scraps", 0) < recipe["scraps"]:
            return False, "Insufficient raw materials for munitions."

        # کسر منابع
        player_data["gold"] -= recipe["gold"]
        player_data["scraps"] -= recipe["scraps"]
        
        # افزودن به زاغه مهمات (Ammo Depot)
        ammo_stock = player_data.get("ammo_depot", {})
        ammo_stock[recipe_id] = ammo_stock.get(recipe_id, 0) + 5 # هر بسته ۵ عدد
        player_data["ammo_depot"] = ammo_stock
        
        return True, f"Production Initiated: 5 units of {recipe['name']} added to Depot."
