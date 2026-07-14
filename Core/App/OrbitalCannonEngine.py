class OrbitalCannonEngine:
    # پارامترهای شلیک مداری
    HE3_COST_PER_SHOT = 50
    DAMAGE_TO_DEFENSE = 500 # آسیب مستقیم به تورت‌ها

    @staticmethod
    def fire_cannon(attacker_data, target_data):
        # بررسی سوخت (هلیوم-۳ استخراج شده در ماه)
        he3_balance = attacker_data.get("he3_reserve", 0)
        if he3_balance < OrbitalCannonEngine.HE3_COST_PER_SHOT:
            return False, f"Insufficient Helium-3 fuel. Need {OrbitalCannonEngine.HE3_COST_PER_SHOT} He-3."

        # کسر سوخت
        attacker_data["he3_reserve"] -= OrbitalCannonEngine.HE3_COST_PER_SHOT

        # تخریب پدافند هدف (تورت‌ها)
        defenses = target_data.get("defenses", {})
        if not defenses or sum(defenses.values()) == 0:
            return True, "Orbital Strike hit the ground. No turrets detected to destroy."

        # حذف تصادفی یکی از تورت‌ها یا کاهش لول آن‌ها
        import random
        target_turret = random.choice(list(defenses.keys()))
        if defenses[target_turret] > 0:
            defenses[target_turret] -= 1
            target_data["defenses"] = defenses
            return True, f"Direct Hit! One {target_turret} has been vaporized from orbit."
        
        return False, "Targeting system error. No active defenses found."
