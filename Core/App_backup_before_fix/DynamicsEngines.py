import random
import time

class WorldEvents:
    """CMD_935: مدیریت رویدادهای تصادفی جهانی."""
    EVENTS = [
        {"id": "solar_flare", "name": "Solar Flare", "effect": "Mining Rate +50%", "duration": 3600},
        {"id": "neural_damp", "name": "Neural Dampener", "effect": "Arena Power -20%", "duration": 1800},
        {"id": "data_meteor", "name": "Data Meteor", "effect": "Free IXP Caches appearing!", "duration": 900}
    ]
    CURRENT_EVENT = None

    @staticmethod
    def trigger_random_event():
        WorldEvents.CURRENT_EVENT = random.choice(WorldEvents.EVENTS)
        WorldEvents.CURRENT_EVENT["start_time"] = time.time()
        return WorldEvents.CURRENT_EVENT

class CyberShield:
    """CMD_936: دفاع در برابر ویروس‌های سایبری که IXP می‌دزدند."""
    @staticmethod
    def generate_threat():
        return {"threat_id": random.randint(100, 999), "strength": random.randint(1, 10)}

class ArtifactEngine:
    """CMD_937: سیستم اشیاء باستانی و کمیاب (Hidden Artifacts)."""
    ARTIFACTS = [
        {"id": "void_shard", "name": "Void Shard", "rarity": "Legendary", "buff": "+2% Overall Efficiency"},
        {"id": "prime_code", "name": "Prime Code", "rarity": "Epic", "buff": "+5% Defense"}
    ]

    @staticmethod
    def find_artifact(chance=0.01):
        if random.random() < chance:
            return random.choice(ArtifactEngine.ARTIFACTS)
        return None
