class WarpEngine:
    # پارامترهای پورتال
    WARP_COST = {"gold": 10000, "nsm_soft": 500, "energy": 10}

    @staticmethod
    def initiate_jump(player_data, target_sector):
        # بررسی منابع برای پرش کوانتومی
        if player_data.get("gold", 0) < WarpEngine.WARP_COST["gold"] or \
           player_data.get("nsm_soft", 0) < WarpEngine.WARP_COST["nsm_soft"] or \
           player_data.get("energy", 0) < WarpEngine.WARP_COST["energy"]:
            return False, "Insufficient resources for Warp Ignition."

        # کسر منابع
        player_data["gold"] -= WarpEngine.WARP_COST["gold"]
        player_data["nsm_soft"] -= WarpEngine.WARP_COST["nsm_soft"]
        player_data["energy"] -= WarpEngine.WARP_COST["energy"]
        
        # ثبت جابجایی در حافظه (تغییر موقعیت استراتژیک)
        player_data["current_sector"] = target_sector
        return True, f"Warp Jump Successful! Troops materialized in {target_sector}."
