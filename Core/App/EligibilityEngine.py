class EligibilityEngine:
    @staticmethod
    def validate_commander(player_data):
        from Core.App.ChronicleEngine import ChronicleEngine
        
        checks = {
            "wallet_linked": player_data.get("ton_wallet") is not None,
            "human_verified": player_data.get("is_verified_human", False),
            "min_level": player_data.get("town_hall_level", 1) >= 3,
            "honor_score": ChronicleEngine.calculate_total_honor(player_data) >= 1000,
            "account_integrity": player_data.get("integrity_score", 100) >= 80
        }
        
        is_eligible = all(checks.values())
        return is_eligible, checks

    @staticmethod
    def certify_for_mainnet(player_data):
        eligible, checks = EligibilityEngine.validate_commander(player_data)
        if eligible:
            player_data["mainnet_certified"] = True
            return True, "Commander Certified for Mainnet Airdrop."
        return False, "Eligibility criteria not met. Complete all tasks."
