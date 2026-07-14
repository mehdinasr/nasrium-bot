import time

class MarketEngine:
    # لیست کالاهای عرضه شده {listing_id: {seller_id, item_id, price, amount}}
    ACTIVE_LISTINGS = {}

    @staticmethod
    def list_item(player_data, item_id, amount, price):
        # بررسی موجودی کالا در اینونتوری بازیکن
        inventory = player_data.get("consumables", {})
        if inventory.get(item_id, 0) < amount:
            return False, "Insufficient items in reserve."

        listing_id = f"LIST-{int(time.time())}-{player_data['user_id']}"
        MarketEngine.ACTIVE_LISTINGS[listing_id] = {
            "seller_id": player_data["user_id"],
            "seller_name": player_data.get("username", "Unknown"),
            "item_id": item_id,
            "amount": amount,
            "price": price
        }

        # کسر موقت از اینونتوری فروشنده
        inventory[item_id] -= amount
        return True, f"Item listed on Shadow Exchange. ID: {listing_id}"

    @staticmethod
    def buy_item(buyer_data, listing_id, seller_data):
        listing = MarketEngine.ACTIVE_LISTINGS.get(listing_id)
        if not listing: return False, "Listing expired or removed."

        if buyer_data["nsm_soft"] < listing["price"]:
            return False, "Insufficient NSM Soft for this acquisition."

        # انتقال وجه و کسر کارمزد ۱۰ درصدی امپراتوری
        tax = int(listing["price"] * 0.10)
        net_payment = listing["price"] - tax
        
        buyer_data["nsm_soft"] -= listing["price"]
        seller_data["nsm_soft"] = seller_data.get("nsm_soft", 0) + net_payment
        
        # انتقال کالا به خریدار
        b_inv = buyer_data.get("consumables", {})
        b_inv[listing["item_id"]] = b_inv.get(listing["item_id"], 0) + listing["amount"]
        buyer_data["consumables"] = b_inv

        del MarketEngine.ACTIVE_LISTINGS[listing_id]
        return True, f"Transaction Secure. Item acquired. Imperial Tax: {tax} NSM."
