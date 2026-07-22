class QuestEngine:
    # تعریف لیست ماموریت های ایردراپ
    AIRDROP_QUESTS = {
        "q_raid_master": {"name": "Raid Master", "goal": 5, "type": "raids", "pts": 500, "desc": "Win 5 PvP Raids"},
        "q_stake_expert": {"name": "Token Staker", "goal": 2000, "type": "staking", "pts": 1000, "desc": "Stake 2000 NSM in Vault"},
        "q_social_leader": {"name": "Empire Herald", "goal": 2, "type": "referrals", "pts": 800, "desc": "Invite 2 new citizens"}
    }

    @staticmethod
    def get_quest_status(player_data):
        completed = player_data.get("completed_airdrop_quests", [])
        quests = []
        
        # بررسی پیشرفت هر ماموریت
        for qid, info in QuestEngine.AIRDROP_QUESTS.items():
            current_val = 0
            if info["type"] == "raids": current_val = player_data.get("raid_wins", 0)
            elif info["type"] == "staking": current_val = player_data.get("vault_staked", 0)
            elif info["type"] == "referrals": current_val = len(player_data.get("invited_users", []))
            
            is_done = qid in completed
            progress = min(100, int((current_val / info["goal"]) * 100))
            
            quests.append({
                "id": qid,
                "name": info["name"],
                "desc": info["desc"],
                "progress": progress,
                "points": info["pts"],
                "is_completed": is_done,
                "can_claim": progress >= 100 and not is_done
            })
        return quests

    @staticmethod
    def claim_quest(player_data, quest_id):
        quests = QuestEngine.get_quest_status(player_data)
        target = next((q for q in quests if q["id"] == quest_id), None)
        
        if not target or not target["can_claim"]:
            return False, "Quest not eligible for claim."

        # اضافه کردن به لیست تکمیل شده ها و اعمال امتیاز ایردراپ
        completed = player_data.get("completed_airdrop_quests", [])
        completed.append(quest_id)
        player_data["completed_airdrop_quests"] = completed
        
        # امتیاز ایردراپ مستقیما به دیتای بازیکن اضافه می شود
        player_data["airdrop_bonus_points"] = player_data.get("airdrop_bonus_points", 0) + target["points"]
        
        return True, f"Quest {target['name']} claimed! +{target['points']} Airdrop Points."
