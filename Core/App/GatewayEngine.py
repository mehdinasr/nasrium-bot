import time

class GatewayEngine:
    @staticmethod
    def get_system_pulse():
        # تحلیل وضعیت زنده سرور و زیرساخت
        return {
            "status": "OPERATIONAL",
            "latency_ms": 24, # شبیه‌سازی تاخیر
            "node_integrity": "STABLE",
            "timestamp": time.time()
        }

    @staticmethod
    def verify_sync(player_data):
        # بررسی همگام بودن کلاینت و سرور
        last_sync = player_data.get("last_active", 0)
        if time.time() - last_sync > 300: # ۵ دقیقه غیبت
            return False, "Re-synchronization required."
        return True, "Pulse Synchronized."
