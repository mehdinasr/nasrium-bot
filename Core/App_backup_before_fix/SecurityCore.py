import time

class SovereignAdmin:
    """
    CMD_922: ابزارهای نظارتی فرمانده کل.
    """
    @staticmethod
    def get_empire_stats(all_players):
        total_ixp = sum(p.get('intel_xp', 0) for p in all_players)
        total_citizens = len(all_players)
        active_miners = sum(1 for p in all_players if p.get('is_mining', False))
        return {
            "total_citizens": total_citizens,
            "total_ixp_circulation": total_ixp,
            "active_miners": active_miners,
            "system_load": "STABLE",
            "timestamp": time.strftime("%H:%M:%S")
        }

class ImperialShield:
    """
    CMD_923: لایه محافظتی در برابر تقلب و بات‌ها.
    """
    USER_COOLDOWNS = {} # {u_id: last_request_time}

    @staticmethod
    def validate_request(u_id):
        current_time = time.time()
        last_time = ImperialShield.USER_COOLDOWNS.get(u_id, 0)
        
        # جلوگیری از درخواست‌های بیش از حد سریع (Anti-Clicker)
        if (current_time - last_time) < 0.2: # حداکثر ۵ درخواست در ثانیه
            return False, "DEVIANT BEHAVIOR DETECTED: Request rate too high."
        
        ImperialShield.USER_COOLDOWNS[u_id] = current_time
        return True, "SAFE"
