import time

class EmpireEngines:
    # --- CMD_919: Referral Logic ---
    @staticmethod
    def process_referral(referrer_id, new_user_id, all_players):
        referrer = next((p for p in all_players if p['user_id'] == referrer_id), None)
        if referrer:
            referrer['referrals'] = referrer.get('referrals', [])
            if new_user_id not in referrer['referrals']:
                referrer['referrals'].append(new_user_id)
                referrer['intel_xp'] += 2000 # پاداش دعوت
                return True, "Referral Linked. +2000 IXP to Leader."
        return False, "Referrer not found."

    # --- CMD_920: Offline Mining Logic ---
    @staticmethod
    def calculate_offline_earnings(player_data):
        last_seen = player_data.get("last_heartbeat", time.time())
        duration_seconds = time.time() - last_seen
        # نرخ پایه: ۱۰ واحد در ساعت به ازای هر سطح
        rate_per_hour = player_data.get("level", 1) * 10
        earnings = int((duration_seconds / 3600) * rate_per_hour)
        
        if earnings > 0:
            player_data["intel_xp"] += earnings
            player_data["last_heartbeat"] = time.time()
            return earnings
        return 0

    # --- CMD_921: Achievement Logic ---
    ACHIEVEMENTS_LIST = [
        {"id": "pioneer", "name": "First Step", "desc": "Join the Empire", "goal": 1},
        {"id": "rich", "name": "Millionaire", "desc": "Reach 1M IXP", "goal": 1000000},
        {"id": "social", "name": "Recruiter", "desc": "Invite 5 Friends", "goal": 5}
    ]

    @staticmethod
    def check_achievements(player_data):
        owned = player_data.get("achievements", [])
        new_badges = []
        
        # تست شرط میلیونر
        if player_data['intel_xp'] >= 1000000 and "rich" not in owned:
            owned.append("rich"); new_badges.append("Millionaire")
        
        # تست شرط دعوت
        if len(player_data.get("referrals", [])) >= 5 and "social" not in owned:
            owned.append("social"); new_badges.append("Recruiter")
            
        player_data["achievements"] = owned
        return new_badges
