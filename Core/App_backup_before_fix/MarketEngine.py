class MarketEngine:
    """
    مدیریت آیتم‌های بازار سیاه و منطق خرید.
    """
    ITEMS = {
        "overclock_chip": {"name": "Overclock Chip", "price": 2000, "desc": "Increases Arena power by 15%"},
        "stealth_cloak": {"name": "Stealth Cloak", "price": 5000, "desc": "Hides your rank from Leaderboard"},
        "ixp_magnet": {"name": "IXP Magnet", "price": 10000, "desc": "2x production for 24 hours"}
    }

    @staticmethod
    def get_available_items():
        return MarketEngine.ITEMS

    @staticmethod
    def purchase_item(player_data, item_id):
        item = MarketEngine.ITEMS.get(item_id)
        if not item:
            return False, "Item vanished in the shadows."
        
        if player_data.get("intel_xp", 0) < item["price"]:
            return False, "Insufficient IXP. Come back when you're richer."
        
        # کسر هزینه و اضافه کردن آیتم به اینونتوری
        player_data["intel_xp"] -= item["price"]
        player_data["inventory"] = player_data.get("inventory", [])
        player_data["inventory"].append(item_id)
        
        return True, f"Acquired: {item['name']}. Use it wisely."
