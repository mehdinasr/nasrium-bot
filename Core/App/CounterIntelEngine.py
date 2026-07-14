class CounterIntelEngine:
    @staticmethod
    def get_firewall_level(player_data):
        return player_data.get("firewall_level", 1)

    @staticmethod
    def calculate_defense_chance(player_data):
        # شانس پایه دفاع در برابر جاسوس: ۲۰٪ + تاثیر لول فایروال
        f_lvl = CounterIntelEngine.get_firewall_level(player_data)
        return min(80, 20 + (f_lvl * 5))

    @staticmethod
    def log_detected_spy(db, target_id, intruder_name):
        import time
        entry = {
            "target_id": target_id,
            "intruder": intruder_name,
            "timestamp": time.time()
        }
        db.detected_spies.insert_one(entry)
