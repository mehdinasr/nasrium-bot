import time

class WarEngine:
    WAR_DURATION_SECONDS = 24 * 3600
    VICTORY_POINTS = 10
    WINNER_REWARD_GOLD = 5000

    @staticmethod
    def declare_war(syn_a_name, syn_b_name, wars_collection):
        if syn_a_name == syn_b_name:
            return False, "Cannot declare war on your own syndicate."
        existing = wars_collection.find_one({
            "status": "active",
            "$or": [
                {"syndicate_a": syn_a_name, "syndicate_b": syn_b_name},
                {"syndicate_a": syn_b_name, "syndicate_b": syn_a_name}
            ]
        })
        if existing:
            return False, "War already active between these syndicates."

        war_doc = {
            "syndicate_a": syn_a_name,
            "syndicate_b": syn_b_name,
            "score_a": 0,
            "score_b": 0,
            "status": "active",
            "started_at": time.time(),
            "ends_at": time.time() + WarEngine.WAR_DURATION_SECONDS,
            "winner": None
        }
        wars_collection.insert_one(war_doc)
        return True, war_doc

    @staticmethod
    def record_attack_score(attacker_syn, defender_syn, wars_collection):
        if not attacker_syn or not defender_syn or attacker_syn == defender_syn:
            return
        war = wars_collection.find_one({
            "status": "active",
            "$or": [
                {"syndicate_a": attacker_syn, "syndicate_b": defender_syn},
                {"syndicate_a": defender_syn, "syndicate_b": attacker_syn}
            ]
        })
        if not war:
            return
        field = "score_a" if war["syndicate_a"] == attacker_syn else "score_b"
        wars_collection.update_one({"_id": war["_id"]}, {"$inc": {field: WarEngine.VICTORY_POINTS}})

    @staticmethod
    def finalize_if_expired(war, syndicates_collection, wars_collection):
        if war["status"] != "active" or time.time() < war["ends_at"]:
            return war

        if war["score_a"] > war["score_b"]:
            winner = war["syndicate_a"]
        elif war["score_b"] > war["score_a"]:
            winner = war["syndicate_b"]
        else:
            winner = None

        if winner:
            syndicates_collection.update_one(
                {"name": winner},
                {"$inc": {"vault_gold": WarEngine.WINNER_REWARD_GOLD}}
            )

        wars_collection.update_one({"_id": war["_id"]}, {"$set": {"status": "ended", "winner": winner}})
        war["status"] = "ended"
        war["winner"] = winner
        return war
