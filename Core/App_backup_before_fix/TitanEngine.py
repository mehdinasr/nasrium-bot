class TitanEngine:
    # دیتابیس لوکال نمونه برای ذخیره وضعیت تایتان‌های بازیکنان {player_id: [titans]}
    TITAN_REGISTRY = {}

    # مشخصات پیش‌فرض کلاس‌های تایتان
    CLASSES = {
        "DREADNOUGHT": {"base_hp": 5000, "base_atk": 450, "cost_iron": 50000, "cost_gold": 10000},
        "VANGUARD": {"base_hp": 3500, "base_atk": 600, "cost_iron": 40000, "cost_gold": 15000},
        "NEMESIS": {"base_hp": 2500, "base_atk": 850, "cost_iron": 60000, "cost_gold": 25000}
    }

    @staticmethod
    def construct_titan(player_id, class_name):
        cls = class_name.upper()
        if cls not in TitanEngine.CLASSES:
            return False, "Unknown Titan class specifications."
        
        specs = TitanEngine.CLASSES[cls]
        
        # در اینجا فرض بر این است که کسر منابع در لایه PlayerRepository/Wallet قبل از فراخوانی تایید شده است
        new_titan = {
            "titan_id": f"TTN-{cls[:3]}-{len(TitanEngine.TITAN_REGISTRY.get(player_id, [])) + 1}",
            "class": cls,
            "level": 1,
            "hp": specs["base_hp"],
            "atk": specs["base_atk"],
            "status": "READY" # READY, REPAIRING, DEPLOYED
        }

        if player_id not in TitanEngine.TITAN_REGISTRY:
            TitanEngine.TITAN_REGISTRY[player_id] = []
        
        TitanEngine.TITAN_REGISTRY[player_id].append(new_titan)
        return True, new_titan

    @staticmethod
    def upgrade_titan(player_id, titan_id):
        titans = TitanEngine.TITAN_REGISTRY.get(player_id, [])
        titan = next((t for t in titans if t["titan_id"] == titan_id), None)
        
        if not titan:
            return False, "Titan chassis not found in registry."
        
        # افزایش سطح و ضریب قدرت
        titan["level"] += 1
        titan["hp"] = int(titan["hp"] * 1.15)
        titan["atk"] = int(titan["atk"] * 1.20)
        
        return True, titan
