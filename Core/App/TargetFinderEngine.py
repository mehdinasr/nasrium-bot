import time


class TargetFinderEngine:
    @staticmethod
    def find_targets(requester_id, requester_data, players_collection, limit=5):
        requester_level = requester_data.get("town_hall_level", 1)
        now = time.time()

        candidates = players_collection.find({
            "user_id": {"$ne": requester_id},
            "is_banned": {"$ne": True},
            "$or": [
                {"shield_active_until": {"$exists": False}},
                {"shield_active_until": {"$lt": now}}
            ]
        })

        scored = []
        for c in candidates:
            c_level = c.get("town_hall_level", 1)
            level_diff = abs(c_level - requester_level)
            scored.append((level_diff, c))

        scored.sort(key=lambda x: x[0])
        top = scored[:limit]

        results = []
        for _, c in top:
            results.append({
                "user_id": c.get("user_id"),
                "town_hall_level": c.get("town_hall_level", 1),
                "gold": c.get("gold", 0),
                "troops": c.get("troops", 0)
            })

        return results
