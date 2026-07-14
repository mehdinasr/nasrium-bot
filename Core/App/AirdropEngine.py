class AirdropEngine:
    @staticmethod
    def calculate_points(player_data):
        # فرمول استراتژیک تخصیص امتیاز ناصریوم
        lvl = player_data.get('town_hall_level', 1)
        xp = player_data.get('xp', 0)
        invites = len(player_data.get('invited_users', []))
        staked = player_data.get('vault_staked', 0)
        
        # ۱. امتیاز لول (هر لول ۱۰۰۰ امتیاز)
        lvl_points = lvl * 1000
        # ۲. امتیاز تجربه (هر ۱ واحد XP = ۱ امتیاز)
        xp_points = xp
        # ۳. امتیاز وفاداری/دعوت (هر دعوت ۵۰۰ امتیاز)
        ref_points = invites * 500
        # ۴. امتیاز اقتصادی (هر ۱ توکن استیک شده ۲ امتیاز)
        eco_points = staked * 2
        
        bonus_pts = player_data.get('airdrop_bonus_points', 0)
        total_points = lvl_points + xp_points + ref_points + eco_points + bonus_pts
        
        # تعیین رتبه استحقاق (Tier)
        if total_points > 50000: tier = "Diamond Elite"
        elif total_points > 10000: tier = "Gold Veteran"
        elif total_points > 2000: tier = "Silver Citizen"
        else: tier = "Bronze Recruit"
        
        return {
            "total_points": total_points,
            "tier": tier,
            "breakdown": {
                "level": lvl_points,
                "experience": xp_points,
                "referral": ref_points,
                "staking": eco_points
            }
        }
