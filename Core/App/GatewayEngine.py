class GatewayEngine:
    # هزینه‌های فعال‌سازی گیت بین‌سیاره‌ای
    GATEWAY_CONFIG = {
        "activation_he3": 500,
        "maintenance_nsm_soft": 10000, # هزینه روزانه برای باز ماندن تونل
        "stability_boost": 0.95
    }

    @staticmethod
    def activate_gateway(player_data, planet_id):
        # بررسی وجود کلونی در آن سیاره
        if planet_id not in player_data.get("exo_colonies", []):
            return False, "You must colonize the planet before establishing a Gateway."

        # بررسی منابع (هلیوم-۳ استخراج شده در ماه)
        if player_data.get("he3_reserve", 0) < GatewayEngine.GATEWAY_CONFIG["activation_he3"]:
            return False, f"Insufficient Helium-3 fuel. Need {GatewayEngine.GATEWAY_CONFIG['activation_he3']} He-3."

        # فعال‌سازی گیت
        player_data["he3_reserve"] -= GatewayEngine.GATEWAY_CONFIG["activation_he3"]
        active_gateways = player_data.get("active_gateways", [])
        if planet_id not in active_gateways:
            active_gateways.append(planet_id)
        player_data["active_gateways"] = active_gateways
        
        return True, f"Wormhole Stabilized: Gateway to {planet_id.upper()} is now open for instant transfer."
