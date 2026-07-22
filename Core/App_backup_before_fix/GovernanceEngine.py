import time

class GovernanceEngine:
    # پروپوزال‌های پیش‌فرض سیستم
    PROPOSALS = {
        "p1": {"desc": "Increase Gold Mining by 20%", "votes_yes": 0, "votes_no": 0, "expires": 0},
        "p2": {"desc": "Reduce Troop Training Cost", "votes_yes": 0, "votes_no": 0, "expires": 0}
    }

    @staticmethod
    def get_voting_power(player_data):
        # قدرت رای = مقدار توکن استیک شده در Vault (CMD_274)
        return player_data.get("vault_staked", 0) + 1 # حداقل ۱ قدرت رای برای همه

    @staticmethod
    def cast_vote(db, user_id, proposal_id, vote_type):
        player = db.players.find_one({"user_id": user_id})
        power = GovernanceEngine.get_voting_power(player)
        
        # ثبت رای در کالکشن پروپوزال‌ها
        db.proposals.update_one(
            {"p_id": proposal_id},
            {"$inc": {f"votes_{vote_type}": power}},
            upsert=True
        )
        return True, f"Vote cast with {power} Power!"
