class OrbitalEngine:
    # تعریف ماهواره‌ها و هزینه‌های پرتاب (از خزانه فدراسیون)
    SATELLITES = {
        "aegis_1": {"name": "Aegis-I Scanner", "cost_nsm": 500000, "effect": "Counter-Espionage +50%"},
        "sentinel_x": {"name": "Sentinel-X Interceptor", "cost_nsm": 1000000, "effect": "Raid Mitigation +15%"},
        "solaris": {"name": "Solaris-Prime", "cost_nsm": 750000, "effect": "Federation Energy +5%"}
    }

    @staticmethod
    def launch_satellite(fed_treasury, sat_id):
        sat = OrbitalEngine.SATELLITES.get(sat_id)
        if not sat: return False, "Invalid Satellite Blueprint."

        if fed_treasury.get("balance", 0) < sat["cost_nsm"]:
            return False, "Insufficient Federal Reserves for orbital launch."

        # کسر از خزانه فدراسیون
        fed_treasury["balance"] -= sat["cost_nsm"]
        active_sats = fed_treasury.get("active_satellites", [])
        active_sats.append(sat_id)
        fed_treasury["active_satellites"] = active_sats
        
        return True, f"Ignition Confirmed: {sat['name']} is now in stable orbit."
