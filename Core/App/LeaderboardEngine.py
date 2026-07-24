class LeaderboardEngine:
    @staticmethod
    def get_top_players(players_collection, limit=10):
        cursor = players_collection.find(
            {"is_banned": {"$ne": True}}
        ).sort([("power_score", -1), ("gold", -1)]).limit(limit)

        top_list = []
        for idx, p in enumerate(cursor):
            top_list.append({
                "rank": idx + 1,
                "user_id": p.get("user_id"),
                "power_score": p.get("power_score", 0),
                "gold": p.get("gold", 0),
                "town_hall_level": p.get("town_hall_level", 1)
            })
        return top_list
