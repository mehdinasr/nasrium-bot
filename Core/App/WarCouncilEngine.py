class WarCouncilEngine:
    # فرامین فعال جهانی (در نسخه نهایی از DB خوانده می‌شود)
    ACTIVE_DIRECTIVE = {
        "id": "DIR-ALPHA-01",
        "objective": "Liberate Sector S5",
        "target_sector": "S5",
        "current_progress": 45000,
        "goal": 100000,
        "reward": "+30% Gold Mining in S5",
        "status": "OPERATIONAL"
    }

    @staticmethod
    def get_directive():
        return WarCouncilEngine.ACTIVE_DIRECTIVE

    @staticmethod
    def contribute_to_objective(player_data, amount):
        # مشارکت در هدف جهانی باعث افزایش Honor Points می‌شود
        objective = WarCouncilEngine.ACTIVE_DIRECTIVE
        objective["current_progress"] += amount
        
        # پاداش به بازیکن
        player_data["honor_score"] = player_data.get("honor_score", 0) + int(amount / 100)
        return True, f"Contribution logged. +{int(amount/100)} Honor Points gained."
