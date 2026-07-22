import time

class MiningEngine:
    """
    مدیریت فرآیند استخراج زمانی IXP.
    """
    MINING_RATE = 100 # IXP در هر ساعت
    MAX_DURATION = 8 # حداکثر ۸ ساعت ذخیره‌سازی

    @staticmethod
    def start_mining(player_data):
        if player_data.get("is_mining", False):
            return False, "Extraction already in progress."
        
        player_data["is_mining"] = True
        player_data["mining_start_time"] = time.time()
        return True, "Neural Drones deployed to the core."

    @staticmethod
    def claim_mining(player_data):
        if not player_data.get("is_mining", False):
            return False, "No active extraction found."

        start_time = player_data.get("mining_start_time", time.time())
        elapsed_hours = (time.time() - start_time) / 3600
        
        # محدودیت سقف استخراج
        if elapsed_hours > MiningEngine.MAX_DURATION:
            elapsed_hours = MiningEngine.MAX_DURATION
            
        reward = int(elapsed_hours * MiningEngine.MINING_RATE)
        player_data["intel_xp"] += reward
        player_data["is_mining"] = False
        
        return True, f"Extracted {reward} IXP from the Deep Core."
