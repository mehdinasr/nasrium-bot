class ConsensusEngine:
    @staticmethod
    def analyze_proposal(agent_type, proposal_id):
        # منطق رای‌دهی دستیاران AI بر اساس شخصیت
        # P-01: افزایش تولید طلا | P-02: کاهش هزینه انرژی
        
        logic_map = {
            "accountant": {"P-01": "YES", "P-02": "NO"},
            "tactician": {"P-01": "NO", "P-02": "YES"},
            "sentinel": {"P-01": "YES", "P-02": "YES"},
            "broker": {"P-01": "YES", "P-02": "NO"}
        }
        
        agent_stances = logic_map.get(agent_type, {"P-01": "NEUTRAL", "P-02": "NEUTRAL"})
        return agent_stances.get(proposal_id, "NEUTRAL")

    @staticmethod
    def get_voting_power(player_data, agent_vote, user_vote):
        base_power = 1.0
        # اگر بازیکن توکن استیک کرده باشد، قدرت رای بیشتری دارد
        if player_data.get("vault", {}).get("plan") == "imperial_30":
            base_power = 2.0
            
        # پاداش اجماع: اگر انسان و AI هم‌نظر باشند
        if agent_vote == user_vote.upper():
            base_power *= 1.25
            
        return round(base_power, 2)
