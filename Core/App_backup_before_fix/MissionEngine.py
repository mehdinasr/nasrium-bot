import time
from Core.App.GameConfigEngine import GameConfigEngine

class MissionEngine:
    @staticmethod
    def get_daily_status(player_data):
        last_claim = player_data.get("last_daily_claim", 0)
        cooldown = 86400 # ۲۴ ساعت
        current_time = time.time()
        
        can_claim = (current_time - last_claim) >= cooldown
        remaining = max(0, int(cooldown - (current_time - last_claim)))
        return can_claim, remaining

    @staticmethod
    def claim_daily(player_data):
        can_claim, _ = MissionEngine.get_daily_status(player_data)
        if not can_claim:
            return False, "Rewards not ready yet."

        config = GameConfigEngine.load_config()
        eco_cfg = config.get('economy', {})
        
        # استخراج جوایز از کانفیگ مرکزی (CMD_233)
        rewards = {
            "gold": eco_cfg.get('daily_reward_gold', 5000),
            "nsm_soft": eco_cfg.get('daily_reward_nsm_soft', 50),
            "troops": eco_cfg.get('daily_reward_troops', 2)
        }

        # اعمال جوایز
        player_data['gold'] = player_data.get('gold', 0) + rewards['gold']
        player_data['nsm_soft'] = player_data.get('nsm_soft', 0) + rewards['nsm_soft']
        player_data['troops'] = player_data.get('troops', 0) + rewards['troops']
        player_data['last_daily_claim'] = time.time()
        
        return True, rewards
