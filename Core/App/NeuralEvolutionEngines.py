import time

class EnergySystem:
    """CMD_947: سامانه انرژی کوانتومی برای محدودسازی و مدیریت فعالیت‌ها."""
    MAX_ENERGY = 100
    REGEN_RATE = 1 # ۱ واحد انرژی در هر ۶ دقیقه (۱۰ واحد در ساعت)

    @staticmethod
    def sync_energy(player_data):
        last_sync = player_data.get("last_energy_sync", time.time())
        current_energy = player_data.get("quantum_energy", 100)
        
        elapsed = time.time() - last_sync
        regained = int(elapsed / 360) # هر ۳۶۰ ثانیه ۱ واحد
        
        new_energy = min(EnergySystem.MAX_ENERGY, current_energy + regained)
        player_data["quantum_energy"] = new_energy
        player_data["last_energy_sync"] = time.time()
        return new_energy

class AdvancedShadowMarket:
    """CMD_948: بازار سایه پیشرفته برای کدهای دسترسی سطح بالا."""
    SECRET_ITEMS = {
        "root_key": {"name": "System Root Key", "price": 50000000, "effect": "Access to hidden dev logs"},
        "void_trigger": {"name": "Void Trigger", "price": 25000000, "effect": "Instant 8h mining claim"}
    }

class EvolutionaryAI:
    """CMD_949: هوش مصنوعی خودآموز که بر اساس رفتار کاربر تغییر می‌کند."""
    @staticmethod
    def update_personality(player_data, action_type):
        # تحلیل رفتار کاربر: Dueler, Miner, or Trader
        stats = player_data.get("behavior_stats", {"duels": 0, "mines": 0})
        stats[action_type] = stats.get(action_type, 0) + 1
        player_data["behavior_stats"] = stats
        
        if stats["duels"] > stats["mines"]:
            player_data["ai_personality"] = "Tactical/War-ready"
        else:
            player_data["ai_personality"] = "Industrial/Efficient"
