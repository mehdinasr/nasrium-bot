class RelayStationEngine:
    # پارامترهای فنی ایستگاه‌ها
    STATION_CONFIG = {
        "cost_gold": 150000,
        "cost_scraps": 100,
        "range_increment": 500 # کیلومتر برد اضافی
    }

    @staticmethod
    def build_station(player_data):
        if player_data.get("gold", 0) < RelayStationEngine.STATION_CONFIG["cost_gold"] or \
           player_data.get("scraps", 0) < RelayStationEngine.STATION_CONFIG["cost_scraps"]:
            return False, "Insufficient resources for Relay construction."

        player_data["gold"] -= RelayStationEngine.STATION_CONFIG["cost_gold"]
        player_data["scraps"] -= RelayStationEngine.STATION_CONFIG["cost_scraps"]
        
        stations = player_data.get("relay_stations", 0)
        player_data["relay_stations"] = stations + 1
        
        total_range = (stations + 1) * RelayStationEngine.STATION_CONFIG["range_increment"]
        return True, f"Relay Station Deployed. Total Detection Range: {total_range}km."
