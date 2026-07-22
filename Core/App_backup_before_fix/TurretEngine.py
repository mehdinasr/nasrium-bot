class TurretEngine:
    # تعریف انواع پدافند و هزینه‌ها
    DEFENSES = {
        "plasma": {"name": "Plasma Turret", "cost_gold": 20000, "dmg": 50, "desc": "Anti-Infantry"},
        "tesla": {"name": "Tesla Coil", "cost_gold": 50000, "dmg": 120, "desc": "Chain Lightning"},
        "railgun": {"name": "Railgun Battery", "cost_gold": 120000, "dmg": 300, "desc": "Heavy Anti-Armor"}
    }

    @staticmethod
    def calculate_defense_power(player_data):
        # محاسبه قدرت کل پدافند شهر
        defense_data = player_data.get("defenses", {})
        total_dmg = 0
        for t_id, count in defense_data.items():
            if t_id in TurretEngine.DEFENSES:
                total_dmg += TurretEngine.DEFENSES[t_id]["dmg"] * count
        return total_dmg

    @staticmethod
    def build_turret(player_data, turret_id):
        turret = TurretEngine.DEFENSES.get(turret_id)
        if not turret: return False, "Invalid turret specs."

        if player_data.get("gold", 0) < turret["cost_gold"]:
            return False, "Insufficient gold for perimeter defense."

        player_data["gold"] -= turret["cost_gold"]
        defenses = player_data.get("defenses", {})
        defenses[turret_id] = defenses.get(turret_id, 0) + 1
        player_data["defenses"] = defenses
        
        return True, f"Defense Link Active: {turret['name']} installed."
