class MeritEngine:
    # تعریف دستاوردها و القاب
    ACHIEVEMENTS = {
        "title_raider": {"name": "Shadow Raider", "req_type": "raid_wins", "req_val": 10, "buff": "ATK +2%"},
        "title_tycoon": {"name": "Cyber Tycoon", "req_type": "gold", "req_val": 500000, "buff": "Gold +3%"},
        "title_diplomat": {"name": "Imperial Envoy", "req_type": "referrals", "req_val": 5, "buff": "Airdrop +5%"}
    }

    @staticmethod
    def check_achievements(player_data):
        earned = player_data.get("medals", [])
        new_medals = []
        
        # بررسی شرط هر دستاورد
        for aid, info in MeritEngine.ACHIEVEMENTS.items():
            if aid in earned: continue
            
            val = 0
            if info["req_type"] == "raid_wins": val = player_data.get("raid_wins", 0)
            elif info["req_type"] == "gold": val = player_data.get("gold", 0)
            elif info["req_type"] == "referrals": val = len(player_data.get("invited_users", []))
            
            if val >= info["req_val"]:
                new_medals.append(aid)
        
        if new_medals:
            player_data["medals"] = earned + new_medals
            return True, new_medals
        return False, []

    @staticmethod
    def equip_title(player_data, title_id):
        if title_id not in player_data.get("medals", []):
            return False, "Title not earned yet."
        player_data["active_title"] = MeritEngine.ACHIEVEMENTS[title_id]["name"]
        return True, f"Title {player_data['active_title']} equipped."
