import time

class BroadcastEngine:
    # هزینه ارسال هر پیام جهانی
    BROADCAST_COST = 5000 
    CURRENT_MESSAGE = {"sender": "SYSTEM", "text": "Welcome to Nasrium Empire. Glory to the Commander!", "expires": 0}

    @staticmethod
    def post_message(player_data, text):
        if len(text) > 100:
            return False, "Message too long (Max 100 chars)."
        
        if player_data.get("nsm_soft", 0) < BroadcastEngine.BROADCAST_COST:
            return False, "Insufficient NSM Soft for Global Uplink."

        # کسر هزینه و ثبت پیام
        player_data["nsm_soft"] -= BroadcastEngine.BROADCAST_COST
        
        BroadcastEngine.CURRENT_MESSAGE = {
            "sender": player_data["user_id"],
            "text": text,
            "expires": time.time() + 300 # نمایش برای ۵ دقیقه
        }
        
        return True, "Uplink Established. Your message is broadcasting."
