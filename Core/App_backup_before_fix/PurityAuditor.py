class PurityAuditor:
    """CMD_979: اسکن ناهنجاری‌ها و رفتارهای غیرپاک در اکوسیستم."""
    @staticmethod
    def run_global_audit(all_players):
        anomalies = []
        for p in all_players:
            # شناسایی کاربرانی که به طور غیرمنطقی ثروتمند شده‌اند (احتمال تقلب)
            if p.get("intel_xp", 0) > 10**12: # ۱ تریلیون IXP سقف مشکوک
                anomalies.append(p["user_id"])
        
        return {
            "status": "CLEAN" if not anomalies else "CONTAMINATED",
            "anomalies_found": len(anomalies),
            "flagged_ids": anomalies
        }
