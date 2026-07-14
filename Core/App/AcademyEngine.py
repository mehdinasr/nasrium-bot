class AcademyEngine:
    # تعریف سطوح آموزشی و هزینه‌ها
    UPGRADES = {
        "infantry_lv2": {"name": "Veteran Infantry", "cost_gold": 25000, "cost_crystals": 5, "dmg_bonus": 1.15},
        "drone_lv2": {"name": "Advanced Predator", "cost_gold": 40000, "cost_crystals": 10, "dmg_bonus": 1.25},
        "tank_lv2": {"name": "Steel Vanguard", "cost_gold": 75000, "cost_crystals": 20, "dmg_bonus": 1.40}
    }

    @staticmethod
    def train_unit(player_data, unit_type):
        upgrade_id = f"{unit_type}_lv2"
        upg = AcademyEngine.UPGRADES.get(upgrade_id)
        if not upg: return False, "Unit training path not yet mapped."

        # بررسی موجودی
        if player_data.get("gold", 0) < upg["cost_gold"] or player_data.get("primal_crystals", 0) < upg["cost_crystals"]:
            return False, "Insufficient resources for high-tier cybernetic training."

        # اعمال ارتقا
        player_data["gold"] -= upg["cost_gold"]
        player_data["primal_crystals"] -= upg["cost_crystals"]
        
        troop_levels = player_data.get("troop_levels", {})
        troop_levels[unit_type] = troop_levels.get(unit_type, 1) + 1
        player_data["troop_levels"] = troop_levels
        
        return True, f"Training Complete: Your {unit_type} units have reached {upg['name']} status."
