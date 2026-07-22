class ThemeEngine:
    # تعریف تم‌های در دسترس
    THEMES = {
        "default": {"primary": "#00f3ff", "bg": "rgba(0, 243, 255, 0.05)"},
        "war": {"primary": "#ff4d4d", "bg": "rgba(255, 77, 77, 0.05)"},
        "elite": {"primary": "#f1c40f", "bg": "rgba(241, 196, 15, 0.05)"}
    }

    @staticmethod
    def set_player_theme(player_data, theme_id):
        if theme_id not in ThemeEngine.THEMES:
            return False, "Theme not found."
        player_data["active_theme"] = theme_id
        return True, f"Imperial Interface calibrated to {theme_id} mode."
