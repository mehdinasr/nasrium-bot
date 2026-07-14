import time

class AuctionEngine:
    """
    مدیریت مزایده‌های سلطنتی نصریوم.
    """
    CURRENT_AUCTION = {
        "item_name": "Imperial Sovereign Core",
        "item_desc": "A legendary core that grants 3x Mining Rate forever.",
        "highest_bid": 100000,
        "highest_bidder": "System",
        "end_time": time.time() + 3600 # ۱ ساعت تا پایان
    }

    @staticmethod
    def get_status():
        return AuctionEngine.CURRENT_AUCTION

    @staticmethod
    def place_bid(u_id, bid_amount, player_ixp):
        auction = AuctionEngine.CURRENT_AUCTION
        
        if bid_amount <= auction["highest_bid"]:
            return False, f"Bid must be higher than {auction['highest_bid']}."
        
        if player_ixp < bid_amount:
            return False, "You do not have enough IXP to back this bid."

        if time.time() > auction["end_time"]:
            return False, "The auction has already concluded."

        # ثبت پیشنهاد جدید
        auction["highest_bid"] = bid_amount
        auction["highest_bidder"] = u_id
        # تمدید زمان حراجی در صورت پیشنهاد در دقایق آخر (Anti-Sniping)
        if (auction["end_time"] - time.time()) < 300:
            auction["end_time"] += 300
            
        return True, "Your bid has been recorded by the Royal Court."
