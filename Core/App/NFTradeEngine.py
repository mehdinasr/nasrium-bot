class NFTradeEngine:
    # لیست معاملات فعال در کل شبکه
    # {listing_id: {seller_id, nft_data, price, currency}}
    MARKET_LISTINGS = {}

    @staticmethod
    def list_nft(player_data, asset_id, price, currency="nsm_soft"):
        # پیدا کردن NFT در اینونتوری بازیکن
        nfts = player_data.get("minted_nfts", [])
        target_nft = next((n for n in nfts if n["asset_id"] == asset_id), None)
        
        if not target_nft:
            return False, "NFT not found in your Imperial Vault."

        # انتقال NFT به وضعیت "در حال فروش" و فریز کردن آن
        listing_id = f"LIST-{asset_id}"
        NFTradeEngine.MARKET_LISTINGS[listing_id] = {
            "seller": player_data["user_id"],
            "nft": target_nft,
            "price": price,
            "currency": currency
        }
        
        # حذف موقت از لیست فعال بازیکن
        nfts.remove(target_nft)
        player_data["minted_nfts"] = nfts
        
        return True, f"NFT {asset_id} listed on the Royal Exchange for {price} {currency.upper()}."

    @staticmethod
    def fulfill_trade(buyer_data, listing_id):
        listing = NFTradeEngine.MARKET_LISTINGS.get(listing_id)
        if not listing: return False, "Listing expired or sold."

        price = listing["price"]
        currency = listing["currency"]

        if buyer_data.get(currency, 0) < price:
            return False, f"Insufficient {currency.upper()}."

        # تکمیل مالی: کسر از خریدار (۸۰٪ به فروشنده، ۲۰٪ مالیات امپراتوری)
        buyer_data[currency] -= price
        
        # اضافه کردن NFT به خریدار
        buyer_nfts = buyer_data.get("minted_nfts", [])
        buyer_nfts.append(listing["nft"])
        buyer_data["minted_nfts"] = buyer_nfts
        
        # حذف از بازار
        del NFTradeEngine.MARKET_LISTINGS[listing_id]
        
        return True, "Imperial Asset transferred successfully."
