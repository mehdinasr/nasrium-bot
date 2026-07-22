class ElevatorEngine:
    # هزینه‌های احداث ابرسازه
    CONSTRUCTION_COST = {"gold": 1000000, "scraps": 500, "crystals": 100}
    EFFICIENCY_BOOST = 0.90 # ۹۰٪ کاهش زمان

    @staticmethod
    def build_elevator(player_data):
        # بررسی پیش‌نیاز (باید پایگاه ماه فعال باشد)
        if not player_data.get("lunar_base_active", False):
            return False, "Lunar Outpost required before building the Elevator."

        costs = ElevatorEngine.CONSTRUCTION_COST
        if player_data.get("gold", 0) < costs["gold"] or \
           player_data.get("scraps", 0) < costs["scraps"]:
            return False, "Insufficient materials for this mega-structure."

        # کسر منابع و فعال‌سازی
        player_data["gold"] -= costs["gold"]
        player_data["scraps"] -= costs["scraps"]
        player_data["space_elevator_active"] = True
        
        return True, "Imperial Achievement: The Space Elevator has connected Nasrium to the Stars."

    @staticmethod
    def get_transfer_speed(player_data):
        if player_data.get("space_elevator_active", False):
            return "HYPER-SONIC (Instant)"
        return "CHEMICAL-ROCKET (24h)"
