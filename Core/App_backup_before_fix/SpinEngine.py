import random
import time

class SpinEngine:
    """
    مدیریت پاداش‌های تصادفی و محدودیت‌های زمانی گردونه شانس.
    """
    REWARDS = [
        {"type": "IXP", "amount": 500, "chance": 0.5, "label": "Small IXP Cache"},
        {"type": "IXP", "amount": 2000, "chance": 0.3, "label": "Medium IXP Cache"},
        {"type": "IXP", "amount": 10000, "chance": 0.1, "label": "Jackpot IXP!"},
        {"type": "ITEM", "id": "overclock_chip", "chance": 0.08, "label": "Rare Overclock Chip"},
        {"type": "HONOR", "amount": 50, "chance": 0.02, "label": "Imperial Honor Medal"}
    ]

    @staticmethod
    def can_spin(player_data):
        last_spin = player_data.get("last_spin_time", 0)
        # ۲۴ ساعت فاصله بین هر چرخش (۸۶۴۰۰ ثانیه)
        return (time.time() - last_spin) > 86400

    @staticmethod
    def execute_spin(player_data):
        if not SpinEngine.can_spin(player_data):
            return False, "The Quantum Reactor is cooling down. Wait for 24h."

        # منطق انتخاب پاداش بر اساس شانس
        roll = random.random()
        cumulative = 0
        selected_reward = SpinEngine.REWARDS[0]
        
        for reward in SpinEngine.REWARDS:
            cumulative += reward["chance"]
            if roll <= cumulative:
                selected_reward = reward
                break
        
        # اعمال پاداش
        if selected_reward["type"] == "IXP":
            player_data["intel_xp"] += selected_reward["amount"]
        elif selected_reward["type"] == "HONOR":
            player_data["honor_score"] = player_data.get("honor_score", 0) + selected_reward["amount"]
        elif selected_reward["type"] == "ITEM":
            player_data["inventory"] = player_data.get("inventory", [])
            player_data["inventory"].append(selected_reward["id"])

        player_data["last_spin_time"] = time.time()
        return True, selected_reward["label"]
