class CustomizationEngine:
    # کاتالوگ تم‌های بصری {id: {name, color, cost_hard}}
    VISUAL_THEMES = {
        "default": {"name": "Standard Blue", "color": "#00f3ff", "cost": 0},
        "crimson": {"name": "Rogue Crimson", "color": "#ff4d4d", "cost": 50},
        "royal": {"name": "Imperial Gold", "color": "#f1c40f", "cost": 150},
        "void": {"name": "Abyssal Purple", "color": "#e056fd", "cost": 300}
    }

    @staticmethod
    def apply_customization(player_data, theme_id, ai_name):
        theme = CustomizationEngine.VISUAL_THEMES.get(theme_id)
        if not theme: return False, "Theme blueprint not found in archives."

        # بررسی هزینه (اگر رایگان نباشد)
        if theme["cost"] > 0 and player_data.get("nsm_hard", 0) < theme["cost"]:
            return False, f"Insufficient NSM Hard for {theme['name']} skin."

        # اعمال تغییرات
        player_data["nsm_hard"] = player_data.get("nsm_hard", 0) - theme["cost"]
        player_data["ai_custom_name"] = ai_name
        player_data["ai_active_theme"] = theme_id
        
        return True, f"Neural Core Updated: Your assistant is now known as {ai_name} with {theme['name']} aura."
