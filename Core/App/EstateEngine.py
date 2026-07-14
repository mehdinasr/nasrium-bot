class EstateEngine:
    # تعریف مناطق و هزینه‌های خرید
    DISTRICTS = {
        "dist_ind": {"name": "Industrial Zone", "gold_cost": 250000, "nsm_cost": 10000, "bonus": "Gold +10%"},
        "dist_mil": {"name": "Military Garrison", "gold_cost": 250000, "nsm_cost": 10000, "bonus": "Power +10%"},
        "dist_res": {"name": "Research Hub", "gold_cost": 250000, "nsm_cost": 10000, "bonus": "IXP +10%"}
    }

    @staticmethod
    def purchase_estate(player_data, district_id):
        if district_id not in EstateEngine.DISTRICTS:
            return False, "Invalid District ID."
        
        owned = player_data.get("owned_estates", [])
        if district_id in owned:
            return False, "You already own this District."
        
        if len(owned) >= 2:
            return False, "Maximum District capacity reached (2)."

        dist = EstateEngine.DISTRICTS[district_id]
        if player_data.get("gold", 0) < dist["gold_cost"] or player_data.get("nsm_soft", 0) < dist["nsm_cost"]:
            return False, "Insufficient funds for District acquisition."

        # کسر منابع و ثبت مالکیت
        player_data["gold"] -= dist["gold_cost"]
        player_data["nsm_soft"] -= dist["nsm_cost"]
        owned.append(district_id)
        player_data["owned_estates"] = owned
        
        return True, f"Imperial Deed Issued: You are now the Governor of {dist['name']}."
