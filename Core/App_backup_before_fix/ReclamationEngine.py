class ReclamationEngine:
    @staticmethod
    def salvage_from_losses(lost_troops):
        # بازیابی ۱۰٪ از آهن/ضایعات هر سرباز از دست رفته
        salvaged_scraps = int(lost_troops * 1.5)
        return salvaged_scraps

    @staticmethod
    def dismantle_artifact(player_data, artifact_id):
        artifacts = player_data.get("artifacts", [])
        if artifact_id not in artifacts:
            return False, "Artifact not found in vault."

        from Core.App.ForgeEngine import ForgeEngine
        recipe = ForgeEngine.RECIPES.get(artifact_id.replace("_v2", ""))
        
        # بازیابی ۴۰٪ از منابع مصرف شده در ساخت
        recover_scraps = int(recipe["scrap_cost"] * 0.4)
        recover_nsm = int(recipe["nsm_cost"] * 0.2)

        artifacts.remove(artifact_id)
        player_data["artifacts"] = artifacts
        player_data["scraps"] = player_data.get("scraps", 0) + recover_scraps
        player_data["nsm_soft"] += recover_nsm
        
        return True, f"Dismantled {artifact_id}. Recovered {recover_scraps} Scraps and {recover_nsm} NSM."
