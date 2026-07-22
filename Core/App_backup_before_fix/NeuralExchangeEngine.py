class NeuralExchangeEngine:
    # مهارت‌های قابل معامله {skill_id: {name, description, base_price}}
    SKILL_CATALOG = {
        "raid_analyst": {"name": "Raid Analyst Pro", "desc": "+15% Battle Sim Accuracy", "price": 5000},
        "gold_optimizer": {"name": "Gold Siphon Protocol", "desc": "+10% Extraction Speed", "price": 8000},
        "shield_tech": {"name": "Aegis Overclock", "desc": "Reduced Shield Cooldown by 2h", "price": 12000}
    }

    @staticmethod
    def rent_skill(renter_data, owner_data, skill_id):
        skill = NeuralExchangeEngine.SKILL_CATALOG.get(skill_id)
        if not skill: return False, "Skill module not found in the grid."

        if renter_data.get("nsm_soft", 0) < skill["price"]:
            return False, "Insufficient NSM Soft for neural acquisition."

        # تقسیم وجه و کسر مالیات ۱۰٪ امپراتوری
        tax = int(skill["price"] * 0.10)
        payout = skill["price"] - tax
        
        renter_data["nsm_soft"] -= skill["price"]
        owner_data["nsm_soft"] = owner_data.get("nsm_soft", 0) + payout
        
        # فعال‌سازی موقت مهارت (ساده‌سازی شده)
        active_skills = renter_data.get("rented_skills", {})
        import time
        active_skills[skill_id] = time.time() + 86400 # اعتبار ۲۴ ساعت
        renter_data["rented_skills"] = active_skills
        
        return True, f"Neural Link Established: {skill['name']} is now active. Imperial Tax: {tax} NSM."
