import time

class WarzoneEngine:
    # تعریف بخش‌های نقشه {sector_id: {owner_syn, status, end_time}}
    SECTORS = {
        "SEC_ALPHA": {"name": "Alpha Mining Zone", "owner": "None", "status": "Stable", "bonus": "Gold +20%"},
        "SEC_PRIME": {"name": "Prime AI Hub", "owner": "None", "status": "Stable", "bonus": "IXP +25%"},
        "SEC_OMEGA": {"name": "Omega Forge", "owner": "None", "status": "Stable", "bonus": "Scrap +30%"}
    }

    @staticmethod
    def declare_war(syndicate_name, sector_id):
        sector = WarzoneEngine.SECTORS.get(sector_id)
        if not sector: return False, "Sector coordinates invalid."
        
        if sector["status"] == "At War":
            return False, "This sector is already a Warzone."

        # تغییر وضعیت بخش به حالت جنگ
        sector["status"] = "At War"
        sector["war_start"] = time.time()
        sector["challenger"] = syndicate_name
        return True, f"War Declared! {syndicate_name} is invading {sector['name']}."

    @staticmethod
    def resolve_war(sector_id, winner_syndicate):
        sector = WarzoneEngine.SECTORS.get(sector_id)
        sector["owner"] = winner_syndicate
        sector["status"] = "Stable"
        sector["control_expiry"] = time.time() + 172800 # ۴۸ ساعت کنترل
        return True
