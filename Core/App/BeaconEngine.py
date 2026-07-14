class BeaconEngine:
    # تعریف دکل‌های موجود در شبکه ناصریوم
    BEACONS = {
        "B-01": {"name": "North Pole Relay", "buff": "Energy Regen +20%", "min_influence": 5000},
        "B-02": {"name": "Equator Link", "buff": "Gold Mining +15%", "min_influence": 8000},
        "B-03": {"name": "Lunar Uplink", "buff": "Research Speed +10%", "min_influence": 12000}
    }

    @staticmethod
    def can_capture(syndicate_influence, beacon_id):
        beacon = BeaconEngine.BEACONS.get(beacon_id)
        if not beacon: return False, "Beacon not found."
        if syndicate_influence < beacon["min_influence"]:
            return False, f"Need {beacon['min_influence']} Influence to capture."
        return True, "Capture protocol initiated."

    @staticmethod
    def apply_beacon_buffs(player_data, active_beacons):
        # این تابع در گام‌های آینده برای اصلاح محاسبات تولید استفاده خواهد شد
        pass
