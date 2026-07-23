import time

class SyndicateEngine:
    @staticmethod
    def create_syndicate(player_data, syn_name):
        if player_data.get("syndicate") and player_data.get("syndicate") != "None":
            return False, "Already in a syndicate."
        if len(syn_name) < 3 or len(syn_name) > 15:
            return False, "Name must be 3-15 characters."
        if player_data.get("gold", 0) < 50000:
            return False, "Need 50,000 Gold to form a syndicate."

        player_data["gold"] -= 50000
        new_syn_meta = {
            "name": syn_name,
            "leader": player_data["user_id"],
            "vault_gold": 0,
            "level": 1,
            "members": [player_data["user_id"]]
        }
        player_data["syndicate"] = syn_name
        return True, new_syn_meta

    @staticmethod
    def join_syndicate(player_data, syndicate_doc):
        if player_data.get("syndicate") and player_data.get("syndicate") != "None":
            return False, "Already in a syndicate."
        if not syndicate_doc:
            return False, "Syndicate not found."
        if len(syndicate_doc.get("members", [])) >= 50:
            return False, "Syndicate is full."

        player_data["syndicate"] = syndicate_doc["name"]
        return True, syndicate_doc["name"]

    @staticmethod
    def get_tax_contribution(loot_amount):
        return int(loot_amount * 0.05)

    @staticmethod
    def process_upline_commission(uid, payout_amount, players_collection):
        # 5% referral commission to the direct upline on each withdrawal
        player = players_collection.find_one({"user_id": uid})
        if not player:
            return
        upline_id = player.get("upline_id")
        if not upline_id:
            return
        commission = int(payout_amount * 0.05)
        if commission <= 0:
            return
        players_collection.update_one(
            {"user_id": upline_id},
            {"$inc": {"nsm_hard": commission}}
        )
