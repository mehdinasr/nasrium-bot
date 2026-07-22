class FoundersSenateEngine:
    # پیشنهادات استراتژیک در جریان
    ELITE_PROPOSALS = {
        "EP-01": {"title": "Mainnet Integration Speed", "votes": 0, "threshold": 50},
        "EP-02": {"title": "Treasury Interest Hike", "votes": 0, "threshold": 30}
    }

    @staticmethod
    def submit_elite_proposal(player_data, title):
        # بررسی تگ بنیان‌گذار (Genesis Founder)
        medals = player_data.get("medals", [])
        if "title_founder" not in medals:
            return False, "Access Denied: Founder status required for Elite Senate."
        
        prop_id = f"EP-{len(FoundersSenateEngine.ELITE_PROPOSALS) + 1}"
        FoundersSenateEngine.ELITE_PROPOSALS[prop_id] = {"title": title, "votes": 0, "threshold": 20}
        return True, f"Strategic Proposal {prop_id} submitted to the Nasrium Senate."

    @staticmethod
    def cast_elite_vote(player_data, prop_id):
        medals = player_data.get("medals", [])
        if "title_founder" not in medals:
            return False, "Only Founders can vote in this chamber."
        
        if prop_id not in FoundersSenateEngine.ELITE_PROPOSALS:
            return False, "Proposal not found."

        FoundersSenateEngine.ELITE_PROPOSALS[prop_id]["votes"] += 1
        return True, "Vote registered in the Imperial Archives."
