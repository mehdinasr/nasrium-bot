class ShopEngine:
    # لیست محصولات و قیمت‌ها
    CATALOG = {
        "time_warp": {"name": "Time Warp", "price_soft": 50000, "price_hard": 5, "desc": "Instant Build Completion"},
        "sentinel_shield": {"name": "24h Shield", "price_soft": 0, "price_hard": 10, "desc": "Immunity from Raids"},
        "energy_core": {"name": "Energy Core", "price_soft": 20000, "price_hard": 2, "desc": "Refill 100% Energy"},
        "hero_catalyst": {"name": "Hero Catalyst", "price_soft": 100000, "price_hard": 15, "desc": "Instant Hero Revive"}
    }

    @staticmethod
    def process_purchase(player_data, item_id, currency_type):
        item = ShopEngine.CATALOG.get(item_id)
        if not item: return False, "Item not found in Nasrium Registry."

        price_key = "price_soft" if currency_type == "soft" else "price_hard"
        balance_key = "nsm_soft" if currency_type == "soft" else "nsm_hard"
        
        if item[price_key] <= 0 and currency_type == "soft":
            return False, "This item requires Premium NSM Credits."

        if player_data.get(balance_key, 0) < item[price_key]:
            return False, f"Insufficient {currency_type.upper()} balance."

        # کسر موجودی و ثبت خرید
        player_data[balance_key] -= item[price_key]
        
        # اعمال اثر مستقیم (ساده‌سازی شده)
        if item_id == "energy_core":
            player_data["energy"] = 100
        elif item_id == "sentinel_shield":
            import time
            player_data["shield_until"] = time.time() + 86400
            
        return True, f"Purchase Successful: {item['name']} activated."
