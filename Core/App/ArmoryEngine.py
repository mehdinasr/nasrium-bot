class ArmoryEngine:
    # تعریف اسلات‌های زرادخانه
    SLOTS = ["weapon", "armor", "cpu", "utility"]

    @staticmethod
    def equip_to_slot(player_data, artifact_id, slot_id):
        if slot_id not in ArmoryEngine.SLOTS:
            return False, "Invalid slot identifier."
        
        artifacts = player_data.get("artifacts", [])
        if artifact_id not in artifacts:
            return False, "Artifact not found in vault."

        # مدیریت زرادخانه در دیتای بازیکن
        armory = player_data.get("armory", {})
        armory[slot_id] = artifact_id
        player_data["armory"] = armory
        
        return True, f"Artifact {artifact_id} mounted to {slot_id} slot."

    @staticmethod
    def get_total_bonuses(player_data):
        # تجمیع تمام بونوس‌های تجهیزات نصب شده
        armory = player_data.get("armory", {})
        total_atk = 1.0
        total_def = 1.0
        
        # منطق محاسبه در نسخه‌های آینده بر اساس دیتای متای هر آیتم تکمیل می‌شود
        return {"atk": total_atk, "def": total_def}
