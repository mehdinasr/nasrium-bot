class InventoryEngine:
    @staticmethod
    def get_player_inventory(player_data):
        # دریافت لیست آرتیفکت‌ها و آیتم‌های ویژه
        artifacts = player_data.get("artifacts", [])
        equipped = player_data.get("equipped_artifact", None)
        
        from Core.App.ForgeEngine import ForgeEngine
        all_metadata = ForgeEngine.RECIPES
        
        inventory = []
        for aid in artifacts:
            inventory.append({
                "id": aid,
                "name": all_metadata[aid]["name"],
                "bonus": all_metadata[aid]["bonus"],
                "is_equipped": (aid == equipped)
            })
        return inventory

    @staticmethod
    def equip_artifact(player_data, artifact_id):
        artifacts = player_data.get("artifacts", [])
        if artifact_id not in artifacts:
            return False, "Artifact not found in your vault."
        
        # تجهیز کردن آیتم (فقط یک اسلات اصلی فعلاً)
        player_data["equipped_artifact"] = artifact_id
        return True, f"Artifact {artifact_id} integrated into Core System."
