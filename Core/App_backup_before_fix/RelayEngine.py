class RelayEngine:
    # ساختار پیوندهای فعال {relay_id: {sector_a, sector_b, strength}}
    ACTIVE_LINKS = {}

    @staticmethod
    def establish_link(player_data, sector_a, sector_b):
        # هزینه ایجاد رله: 50,000 طلا و 2,000 NSM Soft
        if player_data.get("gold", 0) < 50000 or player_data.get("nsm_soft", 0) < 2000:
            return False, "Insufficient resources to establish Quantum Relay."

        import time
        relay_id = f"RELAY-{sector_a}-{sector_b}"
        if relay_id in RelayEngine.ACTIVE_LINKS:
            return False, "Relay link already active between these sectors."

        RelayEngine.ACTIVE_LINKS[relay_id] = {
            "origin": player_data["user_id"],
            "sectors": [sector_a, sector_b],
            "synergy_bonus": 0.05,
            "timestamp": time.time()
        }
        
        player_data["gold"] -= 50000
        player_data["nsm_soft"] -= 2000
        return True, f"Quantum Relay established between {sector_a} and {sector_b}."

    @staticmethod
    def get_synergy_multiplier(player_data, sector_id):
        # محاسبه ضریب هم‌افزایی برای یک بخش خاص
        multiplier = 1.0
        for link in RelayEngine.ACTIVE_LINKS.values():
            if sector_id in link["sectors"]:
                multiplier += link["synergy_bonus"]
        return multiplier
