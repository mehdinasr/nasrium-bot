class CraftEngine:
    # گسترش لیست اشیاء برای شامل شدن نسخه های ارتقا یافته
    UPGRADED_ARTIFACTS = {
        "neural_link_v2": {"name": "Neural Link V2", "boost": "atk", "value": 0.35, "desc": "+35% Attack Power"},
        "titanium_hull_v2": {"name": "Titanium Hull V2", "boost": "def", "value": 0.45, "desc": "+45% Defense Power"},
        "quantum_drill_v2": {"name": "Quantum Drill V2", "boost": "gold", "value": 0.55, "desc": "+55% Gold Production"}
    }

    @staticmethod
    def can_synthesize(player_data, item_id):
        # بررسی وجود حداقل ۳ عدد از آیتم مورد نظر
        inventory = player_data.get("inventory", [])
        count = inventory.count(item_id)
        
        # هزینه سنتز: 500 NSM Soft
        has_nsm = player_data.get("nsm_soft", 0) >= 500
        
        return count >= 3 and has_nsm

    @staticmethod
    def execute_synthesis(player_data, item_id):
        if not CraftEngine.can_synthesize(player_data, item_id):
            return False, "Insufficient items or NSM Soft."

        # حذف ۳ آیتم قدیمی
        inventory = player_data.get("inventory", [])
        for _ in range(3):
            inventory.remove(item_id)
        
        # اضافه کردن آیتم جدید
        v2_id = f"{item_id}_v2"
        inventory.append(v2_id)
        
        player_data["inventory"] = inventory
        player_data["nsm_soft"] -= 500
        
        return True, f"Synthesis Successful: {v2_id} created!"
