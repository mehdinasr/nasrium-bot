import time
class PowerEngine:
    @staticmethod
    def calculate_grid_status(player_data):
        buildings = player_data.get("buildings", {})
        
        # محاسبات تولید (فقط از نیروگاه - در اینجا فرض بر نیروگاه در نکسوس است)
        # به ازای هر لول نکسوس 50 واحد برق تولید می‌شود
        total_production = buildings.get("nexus", 1) * 50
        
        # محاسبات مصرف (سایر ساختمان‌ها هر لول 15 واحد برق مصرف می‌کنند)
        total_consumption = 0
        for b_type, lvl in buildings.items():
            if b_type != "nexus":
                total_consumption += lvl * 15
        
        # محاسبه راندمان (Efficiency)
        
        is_sabotaged = time.time() < player_data.get("power_sabotaged_until", 0)
        if is_sabotaged:
            efficiency = 0.3
            status = "SABOTAGED"
        elif total_production >= total_consumption:
    
            efficiency = 1.0
        else:
            # اگر کمبود برق باشد، راندمان کاهش می‌یابد (حداقل 30%)
            efficiency = max(0.3, total_production / total_consumption)
            
        return {
            "production": total_production,
            "consumption": total_consumption,
            "efficiency": round(efficiency, 2),
            "status": "Stable" if efficiency == 1.0 else "Brownout"
        }
