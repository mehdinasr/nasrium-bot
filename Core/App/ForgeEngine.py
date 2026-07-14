import random

class ForgeEngine:
    # تعریف دستورالعمل‌های ساخت آرتیفکت
    RECIPES = {
        "linker": {"name": "Neural Linker", "scrap_cost": 50, "nsm_cost": 1000, "bonus": "gold_prod_5"},
        "plating": {"name": "Titanium Plating", "scrap_cost": 120, "nsm_cost": 2500, "bonus": "hp_boost_10"},
        "qcore": {"name": "Quantum Core", "scrap_cost": 300, "nsm_cost": 6000, "bonus": "radar_cd_15"}
    }

    @staticmethod
    def craft_artifact(player_data, recipe_id):
        recipe = ForgeEngine.RECIPES.get(recipe_id)
        if not recipe: return False, "Invalid Recipe."

        # بررسی منابع (Scraps و NSM Soft)
        scraps = player_data.get("scraps", 0)
        nsm = player_data.get("nsm_soft", 0)

        if scraps < recipe["scrap_cost"] or nsm < recipe["nsm_cost"]:
            return False, "Insufficient Scraps or NSM Soft."

        # کسر منابع
        player_data["scraps"] -= recipe["scrap_cost"]
        player_data["nsm_soft"] -= recipe["nsm_cost"]

        # شانس موفقیت بر اساس هوش قهرمان (پایه ۸۰٪)
        intel = player_data.get("hero_stats", {}).get("intelligence", 10)
        success_chance = 80 + (intel / 5)
        
        if random.randint(1, 100) <= success_chance:
            inventory = player_data.get("artifacts", [])
            inventory.append(recipe_id)
            player_data["artifacts"] = inventory
            return True, f"Synthesis Successful! {recipe['name']} added to collection."
        else:
            return False, "Synthesis Failed. Materials lost in core meltdown."
