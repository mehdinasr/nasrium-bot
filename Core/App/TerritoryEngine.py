class TerritoryEngine:
    # نقشه بخش‌های امپراتوری
    SECTORS = {
        "S1": {"name": "Core Prime", "owner": "None", "influence": {}},
        "S2": {"name": "Neon District", "owner": "None", "influence": {}},
        "S3": {"name": "Shadow Port", "owner": "None", "influence": {}},
        "S4": {"name": "Neural Ridge", "owner": "None", "influence": {}}
    }

    @staticmethod
    def add_influence(sector_id, syndicate_name, points):
        if sector_id not in TerritoryEngine.SECTORS: return False
        
        inf = TerritoryEngine.SECTORS[sector_id]["influence"]
        inf[syndicate_name] = inf.get(syndicate_name, 0) + points
        
        # تعیین مالک جدید (سندیکایی که بیشترین نفوذ را دارد)
        top_owner = max(inf, key=inf.get)
        TerritoryEngine.SECTORS[sector_id]["owner"] = top_owner
        return True

    @staticmethod
    def get_map_data():
        return TerritoryEngine.SECTORS
