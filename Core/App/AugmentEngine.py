class AugmentEngine:
    # تعریف انواع ایمپلنت‌ها و هزینه‌های نصب
    IMPLANTS = {
        "neural_link": {"name": "Neural Link v1", "cost_nsm": 2500, "bonus": "AI Speed +10%", "drain": 2},
        "cyber_eye": {"name": "Cybernetic Eye", "cost_nsm": 2500, "bonus": "Raid Accuracy +15%", "drain": 2},
        "exo_spine": {"name": "Exo-Spine v4", "cost_nsm": 4000, "bonus": "Loot Capacity +20%", "drain": 3}
    }

    @staticmethod
    def install_augment(player_data, augment_id):
        aug = AugmentEngine.IMPLANTS.get(augment_id)
        if not aug: return False, "Augment profile not found."
        
        owned = player_data.get("augments", [])
        if augment_id in owned:
            return False, "This Augmentation is already installed."
        
        if player_data.get("nsm_soft", 0) < aug["cost_nsm"]:
            return False, "Insufficient NSM Soft for bio-augmentation."

        # کسر هزینه و نصب
        player_data["nsm_soft"] -= aug["cost_nsm"]
        owned.append(augment_id)
        player_data["augments"] = owned
        
        return True, f"Surgery Successful: {aug['name']} integrated into your nervous system."
