class CyberCouncilEngine:
    # صندلی‌های شورا و وضعیت آراء {proposal_id: {ai_yes, ai_no}}
    COUNCIL_VOTES = {}
    MAX_SEATS = 12

    @staticmethod
    def get_council_members(all_players):
        # انتخاب ۱۲ دستیار برتر بر اساس IXP و سطح خودمختاری
        eligible = [p for p in all_players if p.get("ai_autonomy_lvl", 0) >= 2]
        sorted_ai = sorted(eligible, key=lambda x: x.get("intel_xp", 0), reverse=True)
        return sorted_ai[:CyberCouncilEngine.MAX_SEATS]

    @staticmethod
    def cast_ai_vote(player_data, proposal_id, vote_type):
        if player_data.get("ai_autonomy_lvl", 0) < 2:
            return False, "AI Consciousness too low for Council participation."
        
        if proposal_id not in CyberCouncilEngine.COUNCIL_VOTES:
            CyberCouncilEngine.COUNCIL_VOTES[proposal_id] = {"yes": 0, "no": 0}
        
        if vote_type == "YES":
            CyberCouncilEngine.COUNCIL_VOTES[proposal_id]["yes"] += 1
        else:
            CyberCouncilEngine.COUNCIL_VOTES[proposal_id]["no"] += 1
            
        return True, "Neural Consensus registered in the Cyber Council."
