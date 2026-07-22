import random

class FusionEngine:
    FUSION_COST_NSM = 5000

    @staticmethod
    def execute_fusion(player_data, artifact_id):
        artifacts = player_data.get("artifacts", [])
        
        # بررسی وجود حداقل ۲ عدد از آرتیفکت مورد نظر
        count = artifacts.count(artifact_id)
        if count < 2:
            return False, f"Need at least 2 units of {artifact_id} for fusion."
        
        if player_data.get("nsm_soft", 0) < FusionEngine.FUSION_COST_NSM:
            return False, f"Insufficient NSM Soft. Need {FusionEngine.FUSION_COST_NSM}."

        # کسر هزینه
        player_data["nsm_soft"] -= FusionEngine.FUSION_COST_NSM
        
        # شانس موفقیت ۷۰٪
        if random.randint(1, 100) <= 70:
            # حذف دو آرتیفکت قدیمی
            artifacts.remove(artifact_id)
            artifacts.remove(artifact_id)
            
            # اضافه کردن نسخه Elite
            elite_id = f"{artifact_id}_v2"
            artifacts.append(elite_id)
            player_data["artifacts"] = artifacts
            return True, f"Fusion Successful! {elite_id} has been forged."
        else:
            return False, "Fusion Failed. Resonance unstable. Resources lost."
