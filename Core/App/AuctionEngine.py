import time

class AuctionEngine:
    # لیست مزایدات فعال {auc_id: {item_name, highest_bid, bidder_id, end_time}}
    ACTIVE_AUCTIONS = {
        "AUC_001": {
            "name": "Sovereign Genesis Core",
            "desc": "Legendary Catalyst: Reduces TH build time by 50% forever.",
            "base_price": 50000,
            "highest_bid": 50000,
            "bidder_name": "Initial Reserve",
            "end_time": time.time() + 86400 # ۲۴ ساعت
        }
    }

    @staticmethod
    def place_bid(player_data, auc_id, bid_amount):
        auc = AuctionEngine.ACTIVE_AUCTIONS.get(auc_id)
        if not auc: return False, "Auction ended or invalid ID."

        if time.time() > auc["end_time"]:
            return False, "This auction is sealed."

        if bid_amount <= auc["highest_bid"]:
            return False, "Your bid must be higher than the current top offer."

        if player_data.get("nsm_soft", 0) < bid_amount:
            return False, "Insufficient NSM Soft to support this bid."

        # ثبت پیشنهاد جدید
        auc["highest_bid"] = bid_amount
        auc["bidder_id"] = player_data["user_id"]
        auc["bidder_name"] = player_data.get("username", "Unknown")
        
        # نکته: در سیستم واقعی وجه در اینجا قفل می‌شود
        return True, f"Bid Registered! You are now the leading contender for {auc['name']}."

    @staticmethod
    def resolve_auctions():
        # بررسی و اهدای آیتم به برندگان (برای گام‌های بعد)
        pass
