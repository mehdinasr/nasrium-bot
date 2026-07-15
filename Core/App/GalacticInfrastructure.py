class GalacticMapEngine:
    """ID_1031: مدیریت مختصات و وضعیت سیارات قابل تسخیر."""
    PLANETS = {
        "CENTAURI_PRIME": {"resources": "High", "danger": 2, "status": "Open"},
        "VOID_SECTOR_4": {"resources": "Extreme", "danger": 8, "status": "Locked"},
        "KRYPTON_STATION": {"resources": "Medium", "danger": 1, "status": "Occupied"}
    }

class P2PExchange:
    """ID_1032: صرافی غیرمتمرکز برای معامله NSM بین شهروندان."""
    OFFERS = [] # [{"seller_id": str, "amount": float, "price_ixp": int}]
    @staticmethod
    def create_offer(u_id, amount, price):
        P2PExchange.OFFERS.append({"seller_id": u_id, "amount": amount, "price_ixp": price})
        return True, "NSM Sale Offer listed in the Open Exchange."

class QuantumSmelter:
    """ID_1033: بازیافت آیتم های اینونتوری به انرژی و مواد اولیه."""
    @staticmethod
    def smelt_item(player_data, item_index):
        inventory = player_data.get("inventory", [])
        if 0 <= item_index < len(inventory):
            removed_item = inventory.pop(item_index)
            # بازگشت بخشی از مقدار IXP یا متریال
            reward = 1000 
            player_data["intel_xp"] += reward
            return True, f"Item {removed_item} smelted. +{reward} IXP recovered."
        return False, "Invalid item index."
