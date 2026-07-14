class GameEngine:
    # هزینه ارتقای Nexus Core
    NEXUS_UPGRADE_COSTS = {
        1: {"gold": 1000, "nsm_soft": 10},
        2: {"gold": 5000, "nsm_soft": 50},
        3: {"gold": 25000, "nsm_soft": 250},
        4: {"gold": 100000, "nsm_soft": 1000},
        5: {"gold": 500000, "nsm_soft": 5000}
    }

    @staticmethod
    def attempt_nexus_upgrade(player_data: dict) -> dict:
        current_level = player_data.get("town_hall_level", 1)
        costs = GameEngine.NEXUS_UPGRADE_COSTS.get(current_level)

        if not costs:
            return {"success": False, "message": "Max level reached"}

        # قانون کلش: معادن باید در سطح فعلی تاون هال مکس باشند!
        buildings = player_data.get("buildings", {"gold_mine": 0, "gem_drill": 0})
        if buildings.get("gold_mine", 0) < current_level or buildings.get("gem_drill", 0) < current_level:
            return {"success": False, "message": "Upgrade Gold Mine & Gem Drill to current Nexus level first!"}

        player_gold = player_data.get("gold", 0)
        player_soft = player_data.get("nsm_soft", 0)

        if player_gold >= costs["gold"] and player_soft >= costs["nsm_soft"]:
            new_level = current_level + 1
            # بررسی آیا در سطح جدید ساختمانها همچنان مکس هستند (احتمالاً خیر)
            is_maxed = (buildings.get("gold_mine", 0) >= new_level and buildings.get("gem_drill", 0) >= new_level)
            
            return {
                "success": True,
                "new_gold": player_gold - costs["gold"],
                "new_nsm_soft": player_soft - costs["nsm_soft"],
                "new_level": new_level,
                "is_nexus_maxed": is_maxed
            }
        
        return {"success": False, "message": "Insufficient resources (Gold or NSM_Soft)"}
