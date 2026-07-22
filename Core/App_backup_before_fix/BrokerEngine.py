import random
import time

class BrokerEngine:
    # لیست کالاهای پایه دلال
    ITEMS = {
        "nano_core": {"name": "Nano-Core (Forge Item)", "base_price": 25000, "currency": "gold"},
        "overdrive": {"name": "Energy Overdrive", "base_price": 2000, "currency": "nsm_soft"},
        "intel": {"name": "Encrypted Intel", "base_price": 5000, "currency": "nsm_soft"}
    }

    @staticmethod
    def get_daily_deals():
        # تولید ۳ پیشنهاد تصادفی با نوسان قیمت
        random.seed(int(time.time() / 43200)) # تغییر هر ۱۲ ساعت
        deals = {}
        for key, info in BrokerEngine.ITEMS.items():
            variance = random.uniform(0.8, 1.5)
            deals[key] = {
                "name": info["name"],
                "price": int(info["base_price"] * variance),
                "currency": info["currency"]
            }
        return deals

    @staticmethod
    def purchase_item(player_data, item_id):
        deals = BrokerEngine.get_daily_deals()
        item = deals.get(item_id)
        if not item: return False, "Item no longer available."

        price = item["price"]
        currency = item["currency"]

        if player_data.get(currency, 0) < price:
            return False, f"Insufficient {currency}."

        player_data[currency] -= price
        # ثبت در بخش دارایی‌های ویژه (ساده‌سازی شده)
        specials = player_data.get("special_items", [])
        specials.append(item_id)
        player_data["special_items"] = specials
        
        return True, f"Successfully acquired {item['name']} from the shadows."
