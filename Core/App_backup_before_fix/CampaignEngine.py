class CampaignEngine:
    # تعریف مراحل کمپین و قدرت دشمن
    STAGES = {
        1: {"name": "Rebel Outpost", "troops": 5, "gold_reward": 2000, "xp_reward": 100},
        2: {"name": "Abandoned Lab", "troops": 15, "gold_reward": 5000, "xp_reward": 250},
        3: {"name": "Supply Depot", "troops": 40, "gold_reward": 12000, "xp_reward": 600},
        4: {"name": "Command Center", "troops": 100, "gold_reward": 30000, "xp_reward": 1500}
    }

    @staticmethod
    def get_player_stage(player_data):
        return player_data.get("campaign_stage", 1)

    @staticmethod
    def attack_stage(db, player_data, stage_id):
        stage = CampaignEngine.STAGES.get(stage_id)
        if not stage: return False, "Invalid Stage.", None

        # شبیه‌سازی نبرد مشابه سیستم Raid اما علیه NPC
        att_power = player_data.get("troops", 0)
        def_power = stage["troops"]

        if att_power > def_power:
            # پیروزی
            loss_percent = 0.2
            losses = int(att_power * loss_percent)
            
            player_data["gold"] += stage["gold_reward"]
            player_data["campaign_stage"] = stage_id + 1
            
            from Core.App.ExperienceEngine import ExperienceEngine
            player_data, _ = ExperienceEngine.add_xp(player_data, stage["xp_reward"])
            
            return True, f"Victory! {stage['name']} neutralized.", {"gold": stage["gold_reward"], "losses": losses}
        else:
            # شکست
            losses = int(att_power * 0.5)
            return False, f"Defeat! The forces of {stage['name']} were too strong.", {"gold": 0, "losses": losses}
