import time

class AuditEngine:
    @staticmethod
    def perform_audit(player_data):
        # تحلیل منطقی دارایی ها
        gold = player_data.get("gold", 0)
        xp = player_data.get("xp", 0)
        lvl = player_data.get("town_hall_level", 1)
        created_at = player_data.get("last_active", time.time()) # در نسخه بعد تاریخ دقیق ثبت نام
        
        # فرمول ساده شناسایی آنومالی:
        # اگر طلای بازیکن نسبت به لولش بسیار غیرمنطقی باشد
        expected_max_gold = (lvl * 100000) + 50000
        
        is_suspicious = gold > expected_max_gold
        integrity_score = 100
        
        if is_suspicious:
            integrity_score = 40
            status = "Anomaly Detected"
        else:
            status = "Verified Clean"
            
        return {
            "score": integrity_score,
            "status": status,
            "timestamp": time.time(),
            "recommendation": "Maintain regular activity" if not is_suspicious else "Contact Support"
        }
