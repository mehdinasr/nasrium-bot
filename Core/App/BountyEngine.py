import time

class BountyEngine:
    # لیست جوایز فعال {target_id: {reward_nsm, posted_by, status}}
    ACTIVE_BOUNTIES = {}

    @staticmethod
    def post_bounty(player_data, target_id, amount):
        if player_data.get("nsm_soft", 0) < amount:
            return False, "Insufficient NSM Soft to post this contract."
        
        if amount < 5000:
            return False, "Minimum bounty reward is 5,000 NSM."

        player_data["nsm_soft"] -= amount
        BountyEngine.ACTIVE_BOUNTIES[target_id] = {
            "reward": amount,
            "posted_by": player_data["user_id"],
            "timestamp": time.time(),
            "status": "WANTED"
        }
        return True, f"Contract Sealed: {amount} NSM placed on {target_id}."

    @staticmethod
    def get_bounties():
        return BountyEngine.ACTIVE_BOUNTIES
