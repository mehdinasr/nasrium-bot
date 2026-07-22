class SenateEngine:
    # پیشنهادات فعال حکومتی
    PROPOSALS = {
        "P-01": {"title": "Gold Rush Protocol", "desc": "+20% Global Gold Production", "votes_yes": 1500, "votes_no": 450},
        "P-02": {"title": "Energy Efficiency", "desc": "-10% Attack Energy Cost", "votes_yes": 800, "votes_no": 900}
    }

    @staticmethod
    def cast_vote(player_data, proposal_id, vote_type):
        if proposal_id not in SenateEngine.PROPOSALS:
            return False, "Proposal not found."
        
        # هزینه هر رای: 500 NSM Soft
        cost = 500
        if player_data.get("nsm_soft", 0) < cost:
            return False, "Insufficient NSM Soft to vote."
            
        player_data["nsm_soft"] -= cost
        
        if vote_type == "yes":
            SenateEngine.PROPOSALS[proposal_id]["votes_yes"] += 1
        else:
            SenateEngine.PROPOSALS[proposal_id]["votes_no"] += 1
            
        return True, f"Vote registered for {proposal_id}."
