class JammingEngine:
    # وضعیت چترهای پارازیت در زون‌های مختلف {zone_id: {active, radius, power_drain, efficiency}}
    JAMMING_ZONES = {}

    @staticmethod
    def activate_jammer(zone_id, radius=50, frequency_level=1):
        # محاسبه بازدهی و مصرف انرژی بر اساس سطح فرکانس
        power_drain = radius * 12 * frequency_level
        efficiency = min(95, 60 + (frequency_level * 5)) # حداکثر ۹۵ درصد کور کردن رادار

        JammingEngine.JAMMING_ZONES[zone_id] = {
            "is_active": True,
            "radius_km": radius,
            "power_drain_mw": power_drain,
            "jamming_efficiency": efficiency
        }
        return True, JammingEngine.JAMMING_ZONES[zone_id]

    @staticmethod
    def get_zone_status(zone_id):
        return JammingEngine.JAMMING_ZONES.get(zone_id, {"is_active": False, "message": "No active ECM in this sector."})
