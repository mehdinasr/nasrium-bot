class DossierEngine:
    """
    تجمیع تمام آمارهای بازیکن در یک پرونده واحد.
    """
    @staticmethod
    def generate_dossier(player_data):
        return {
            "uid": player_data.get("user_id"),
            "rank_title": player_data.get("rank", "Genesis Citizen"),
            "level": player_data.get("level", 1),
            "ixp": player_data.get("intel_xp", 0),
            "honor": player_data.get("honor_score", 0),
            "legion": player_data.get("legion", "No Legion"),
            "partner": player_data.get("union_partner", "Unlinked"),
            "items_count": len(player_data.get("inventory", [])),
            "pioneer_status": player_data.get("is_pioneer", False)
        }
