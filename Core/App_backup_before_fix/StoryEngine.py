class StoryEngine:
    # تعریف فصول و مراحل داستانی
    CHRONICLES = {
        "CH1_1": {
            "title": "The Awakening",
            "lore": "The first AI pulse was detected in the ruins of the old net. Nasrium was born.",
            "goal": "Build 2 Resource Extractors",
            "reward": 10000,
            "next": "CH1_2"
        },
        "CH1_2": {
            "title": "Digital Sovereign",
            "lore": "To rule the metropolis, one must first stabilize the grid.",
            "goal": "Reach Town Hall Level 3",
            "reward": 25000,
            "next": "CH2_1"
        }
    }

    @staticmethod
    def get_active_quest(player_data):
        current_id = player_data.get("current_story_id", "CH1_1")
        return StoryEngine.CHRONICLES.get(current_id)

    @staticmethod
    def complete_step(player_data):
        current_id = player_data.get("current_story_id", "CH1_1")
        quest = StoryEngine.CHRONICLES.get(current_id)
        
        if not quest: return False, "All current chronicles archived."

        # اعطای پاداش و انتقال به مرحله بعد
        player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + quest["reward"]
        player_data["current_story_id"] = quest["next"]
        
        return True, f"Chronicle Sealed: {quest['title']} completed. {quest['reward']} NSM awarded."
