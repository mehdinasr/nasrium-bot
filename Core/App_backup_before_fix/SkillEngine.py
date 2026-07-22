class SkillEngine:
    # تعریف مهارت‌های پایه امپراتوری
    SKILLS = {
        "tactician": {"name": "Tactician", "cost_xp": 1000, "desc": "+10% ATK Power"},
        "architect": {"name": "Architect", "cost_xp": 1000, "desc": "-20% Build Time"},
        "tycoon": {"name": "Tycoon", "cost_xp": 1000, "desc": "+15% Gold Mining"}
    }

    @staticmethod
    def get_skill_bonus(player_data, skill_id):
        unlocked = player_data.get("unlocked_skills", [])
        if skill_id in unlocked:
            if skill_id == "tactician": return 0.10
            if skill_id == "architect": return 0.20
            if skill_id == "tycoon": return 0.15
        return 0.0

    @staticmethod
    def upgrade_skill(player_data, skill_id):
        unlocked = player_data.get("unlocked_skills", [])
        if skill_id in unlocked: return False, "Skill already mastered."
        
        cost = SkillEngine.SKILLS[skill_id]["cost_xp"]
        if player_data.get("xp", 0) < cost:
            return False, f"Insufficient XP. Need {cost}."

        player_data["xp"] -= cost
        unlocked.append(skill_id)
        player_data["unlocked_skills"] = unlocked
        return True, f"Mastered Skill: {SkillEngine.SKILLS[skill_id]['name']}!"
