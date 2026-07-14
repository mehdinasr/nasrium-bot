class NeuralMarketEngine:
    # لیست خدمات فعال در بازار (در دیتابیس مرکزی ذخیره می‌شود)
    # ساختار: {seller_id: {"skill": routine_id, "lvl": level, "price": nsm}}
    MARKET_LISTINGS = {}

    @staticmethod
    def list_service(player_data, routine_id, price_nsm):
        evo_data = player_data.get("ai_evolution", {})
        lvl = evo_data.get(routine_id, 0)
        
        if lvl == 0:
            return False, "You must evolve this sub-routine before listing."
        
        NeuralMarketEngine.MARKET_LISTINGS[player_data["user_id"]] = {
            "skill": routine_id,
            "level": lvl,
            "price": price_nsm
        }
        return True, f"AI Skill {routine_id} (Lv {lvl}) listed for {price_nsm} NSM."

    @staticmethod
    def purchase_service(buyer_data, seller_id):
        listing = NeuralMarketEngine.MARKET_LISTINGS.get(seller_id)
        if not listing: return False, "Service no longer available."

        if buyer_data.get("nsm_soft", 0) < listing["price"]:
            return False, "Insufficient NSM Soft."

        # توزیع ثروت: ۸۰٪ به فروشنده، ۲۰٪ مالیات (Burn)
        tax = int(listing["price"] * 0.20)
        net_profit = listing["price"] - tax
        
        buyer_data["nsm_soft"] -= listing["price"]
        # اعمال بونوس موقت به خریدار (در اینجا بونوس در دیتابیس ثبت می‌شود)
        buyer_data["temp_ai_buff"] = {"skill": listing["skill"], "lvl": listing["level"]}
        
        return True, f"Neural Link established with {seller_id}'s Agent. Buff active.", net_profit
