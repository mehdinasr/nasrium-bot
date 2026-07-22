class ExoColonyEngine:
    # مقاصد کهکشانی و ضرایب آن‌ها
    PLANETS = {
        "mars": {"name": "Mars Red Sector", "multiplier": 50, "cost_hard": 1000, "life_support": 100},
        "titan": {"name": "Titan Gas Hub", "multiplier": 80, "cost_hard": 2500, "life_support": 250},
        "europa": {"name": "Europa Ice Core", "multiplier": 100, "cost_hard": 5000, "life_support": 500}
    }

    @staticmethod
    def found_colony(player_data, planet_id):
        planet = ExoColonyEngine.PLANETS.get(planet_id)
        if not planet: return False, "Coordinates lead to dead space."

        # هزینه تاسیس (بسیار سنگین - مخصوص نخبگان)
        if player_data.get("nsm_hard", 0) < planet["cost_hard"]:
            return False, f"Insufficient NSM Hard for Interstellar Colonization. Need {planet['cost_hard']} 💎"

        if planet_id in player_data.get("exo_colonies", []):
            return False, "You already have a command center on this planet."

        # ثبت کلونی
        player_data["nsm_hard"] -= planet["cost_hard"]
        colonies = player_data.get("exo_colonies", [])
        colonies.append(planet_id)
        player_data["exo_colonies"] = colonies
        
        return True, f"Planet {planet['name']} has been colonized. 100x Resource Yield initiated."
