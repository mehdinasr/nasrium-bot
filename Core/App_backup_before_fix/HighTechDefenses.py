import random

class BlackHoleDefense:
    """ID_1037: سیستم دفاعی برای تخلیه انرژی مهاجمان در نبردهای آرنا."""
    @staticmethod
    def calculate_drain(attacker_energy):
        # جذب 25 درصد از انرژی مهاجم به نفع مدافع
        drain_amount = attacker_energy * 0.25
        return drain_amount

class RelicDiscovery:
    """ID_1038: مدیریت اشیاء باستانی با بوف های دائمی و تغییرناپذیر."""
    RELICS = {
        "EYE_OF_NASRIUM": {"boost": "Critical Hit +15%", "rarity": "Legendary"},
        "VOID_ENGINE": {"boost": "Warp Speed +20%", "rarity": "Mythic"}
    }
    @staticmethod
    def try_discover():
        if random.random() < 0.005: # نیم درصد شانس در هر استخراج
            return random.choice(list(RelicDiscovery.RELICS.keys()))
        return None

class BountyGuild:
    """ID_1039: انجمن شکارچیان برای ثبت قرارداد روی متخلفین."""
    CONTRACTS = [] # [{"target_id": str, "reward_nsm": float, "issued_by": str}]
    @staticmethod
    def post_bounty(u_id, target_id, reward):
        BountyGuild.CONTRACTS.append({
            "target_id": target_id,
            "reward_nsm": reward,
            "issued_by": u_id
        })
        return True, f"Bounty on {target_id} has been broadcasted to the Guild."
