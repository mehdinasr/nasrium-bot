class ReconEngine:
    @staticmethod
    def perform_scan(attacker_data, target_data):
        # بررسی سطح هوش دستیار برای تعیین دقت اسکن
        intelligence = attacker_data.get("hero_stats", {}).get("intelligence", 10)
        
        # اطلاعاتی که فاش می‌شود
        report = {
            "target_id": target_data["user_id"],
            "wall_level": target_data.get("buildings", {}).get("cyber_wall", 0),
            "troop_count": target_data.get("troops", 0),
            "shield_active": target_data.get("shield_until", 0) > 0,
            "integrity": target_data.get("integrity_score", 100)
        }
        
        # اگر هوش پایین باشد، برخی داده‌ها مخفی می‌مانند
        if intelligence < 20:
            report["troop_count"] = "Unknown"
        
        return report
