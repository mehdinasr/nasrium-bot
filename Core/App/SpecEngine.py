class SpecEngine:
    # تعریف آرکتایپ‌ها و تغییرات ضرایب
    ARCHETYPES = {
        "dreadnought": {"name": "Dreadnought", "desc": "Combat Focus: +20% ATK, -10% Gold", "atk_mult": 1.20, "gold_mult": 0.90},
        "technocrat": {"name": "Arch-Technocrat", "desc": "Economy Focus: +25% Gold, -15% ATK", "atk_mult": 0.85, "gold_mult": 1.25},
        "broker": {"name": "Shadow Broker", "desc": "AI Focus: +30% AI Speed, +25% Stealth", "ai_mult": 1.30, "stealth_mult": 1.25}
    }

    @staticmethod
    def set_specialization(player_data, spec_id):
        if spec_id not in SpecEngine.ARCHETYPES:
            return False, "Invalid Archetype ID."
        
        # هزینه تغییر تخصص (اگر قبلا انتخاب شده باشد)
        current_spec = player_data.get("specialization")
        if current_spec and current_spec != "None":
            if player_data.get("gold", 0) < 50000:
                return False, "Insufficient Gold (50,000 required) to retrain commands."
            player_data["gold"] -= 50000

        player_data["specialization"] = spec_id
        return True, f"Command reassigned: You are now a {SpecEngine.ARCHETYPES[spec_id]['name']}."
