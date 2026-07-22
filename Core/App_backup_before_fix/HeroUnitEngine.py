class HeroUnitEngine:
    # تعریف انواع قهرمانان
    HEROES = {
        "vanguard": {"name": "Col. Stryker (Vanguard)", "cost_nsm": 5000, "bonus": "Attack +10%"},
        "guardian": {"name": "Maj. Aegis (Guardian)", "cost_nsm": 5000, "bonus": "Defense +15%"},
        "logistics": {"name": "Capt. Flux (Logistics)", "cost_nsm": 5000, "bonus": "Energy Regen +20%"}
    }

    @staticmethod
    def hire_hero(player_data, hero_id):
        if player_data.get("active_hero"):
            return False, "You already have an active Field Commander."
        
        hero = HeroUnitEngine.HEROES.get(hero_id)
        if not hero: return False, "Hero not found."

        if player_data.get("nsm_soft", 0) < hero["cost_nsm"]:
            return False, "Insufficient NSM Soft to hire this Commander."

        player_data["nsm_soft"] -= hero["cost_nsm"]
        player_data["active_hero"] = {
            "id": hero_id,
            "name": hero["name"],
            "level": 1,
            "xp": 0
        }
        return True, f"Field Commander {hero['name']} has joined your ranks."

    @staticmethod
    def add_hero_xp(hero_data, amount):
        hero_data["xp"] += amount
        if hero_data["xp"] >= (hero_data["level"] * 1000):
            hero_data["level"] += 1
            hero_data["xp"] = 0
            return True # Level Up
        return False
