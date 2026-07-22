import random
from datetime import datetime, timedelta

class QuantumEngine:
    """
    موتور تحلیل احتمالات و پیش‌بینی رویدادهای آینده نصریوم.
    """
    POSSIBLE_EVENTS = [
        {"type": "AIRDROP", "msg": "Meteor Shower of IXP Tokens detected in Sector 7.", "chance": 0.3},
        {"type": "MARKET", "msg": "Quantum Bull Run: 2x Production for 2 hours.", "chance": 0.2},
        {"type": "CRISIS", "msg": "System Breach incoming. Strengthen Firewall nodes.", "chance": 0.1},
        {"type": "DISCOVERY", "msg": "Ancient AI Core signal found. Treasure hunt starts soon.", "chance": 0.4}
    ]

    @staticmethod
    def get_vision():
        # تولید یک رویداد رندوم بر اساس زمان فعلی
        random.seed(datetime.now().strftime("%Y%m%d%H")) # تغییر هر ساعت
        vision = random.choice(QuantumEngine.POSSIBLE_EVENTS)
        
        # زمان تخمینی وقوع
        eta = (datetime.now() + timedelta(minutes=random.randint(45, 180))).strftime("%H:%M UTC")
        
        return {
            "vision_title": vision["type"],
            "description": vision["msg"],
            "probability": f"{int(vision['chance'] * 100)}%",
            "estimated_time": eta
        }
