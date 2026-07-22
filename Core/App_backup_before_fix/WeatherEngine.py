import random
import time

class WeatherEngine:
    # تعریف وضعیت‌های جوی و ضرایب آن‌ها
    STATES = {
        "CLEAR": {"name": "Clear Sky", "prod_mod": 1.0, "ai_mod": 1.0, "energy_mod": 1.0, "color": "#00f3ff"},
        "ACID_RAIN": {"name": "Acid Rain", "prod_mod": 0.9, "ai_mod": 1.0, "energy_mod": 1.0, "color": "#adff2f"},
        "NEON_STORM": {"name": "Neon Storm", "prod_mod": 1.0, "ai_mod": 1.15, "energy_mod": 1.0, "color": "#e056fd"},
        "SOLAR_FLARE": {"name": "Solar Flare", "prod_mod": 1.0, "ai_mod": 0.9, "energy_mod": 1.2, "color": "#f1c40f"}
    }

    CURRENT_WEATHER = "CLEAR"
    LAST_UPDATE = 0

    @staticmethod
    def update_weather():
        # تغییر وضعیت هر ۶ ساعت (ساده‌سازی شده برای تست)
        WeatherEngine.CURRENT_WEATHER = random.choice(list(WeatherEngine.STATES.keys()))
        WeatherEngine.LAST_UPDATE = time.time()
        return WeatherEngine.STATES[WeatherEngine.CURRENT_WEATHER]

    @staticmethod
    def get_current():
        return WeatherEngine.STATES[WeatherEngine.CURRENT_WEATHER]
