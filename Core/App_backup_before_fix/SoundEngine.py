class SoundEngine:
    # نقشه اصوات امپراتوری (لینک‌های استاندارد صوتی)
    SOUND_MAP = {
        "click": "https://nasrium.com/assets/sfx/click.mp3",
        "raid": "https://nasrium.com/assets/sfx/war_horn.mp3",
        "success": "https://nasrium.com/assets/sfx/level_up.mp3",
        "alert": "https://nasrium.com/assets/sfx/alarm.mp3"
    }

    @staticmethod
    def get_sensory_config(player_data):
        return {
            "sound_enabled": player_data.get("sound_on", True),
            "haptic_enabled": player_data.get("haptic_on", True),
            "sounds": SoundEngine.SOUND_MAP
        }
