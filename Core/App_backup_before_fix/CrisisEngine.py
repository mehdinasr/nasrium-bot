import random
import time

class CrisisEngine:
    # تعریف انواع آنومالی‌ها
    ANOMALIES = {
        "solar_flare": {"name": "Solar Flare", "desc": "Gold Mining -30% | Energy Regen +50%", "gold_mult": 0.7, "energy_mult": 1.5},
        "cyber_blackout": {"name": "Cyber Blackout", "desc": "Shields Offline | Loot +100%", "gold_mult": 1.0, "loot_mult": 2.0},
        "neural_resonance": {"name": "Neural Resonance", "desc": "Research Speed +50% | XP Gain +30%", "xp_mult": 1.3, "research_mult": 1.5}
    }
    
    CURRENT_CRISIS = None
    EXPIRES_AT = 0

    @staticmethod
    def get_current_anomaly():
        if time.time() > CrisisEngine.EXPIRES_AT:
            # شانس ۱۰ درصدی برای وقوع بحران در هر بار چک کردن (یا بر اساس کرون‌جاب)
            if random.random() < 0.1:
                key = random.choice(list(CrisisEngine.ANOMALIES.keys()))
                CrisisEngine.CURRENT_CRISIS = CrisisEngine.ANOMALIES[key]
                CrisisEngine.EXPIRES_AT = time.time() + random.randint(3600, 10800) # ۱ تا ۳ ساعت
            else:
                CrisisEngine.CURRENT_CRISIS = None
        
        return CrisisEngine.CURRENT_CRISIS
