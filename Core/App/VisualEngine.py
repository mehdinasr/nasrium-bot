class VisualEngine:
    """
    مدیریت تم‌های بصری و شخصی‌سازی محیط نصریوم.
    """
    THEMES = {
        "obsidian": {"bg": "#000000", "accent": "#00ff00", "name": "Obsidian Protocol (Default)"},
        "imperial": {"bg": "#1a1a00", "accent": "#ffd700", "name": "Imperial Gold"},
        "plasma":   {"bg": "#00001a", "accent": "#e056fd", "name": "Plasma Neon"}
    }

    @staticmethod
    def get_themes():
        return VisualEngine.THEMES

    @staticmethod
    def set_user_theme(player_data, theme_id):
        if theme_id in VisualEngine.THEMES:
            player_data["preferred_theme"] = theme_id
            return True, f"Environment recalibrated to {VisualEngine.THEMES[theme_id]['name']}."
        return False, "Theme core not found."
