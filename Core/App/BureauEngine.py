class BureauEngine:
    # تعریف انواع پهپادهای عملیاتی
    DRONE_TYPES = {
        "aegis": {"name": "Aegis Sentinel", "cost_nsm": 5000, "type": "defense", "bonus": 0.20},
        "seeker": {"name": "Seeker Scout", "cost_nsm": 3000, "type": "intel", "bonus": 0.0}
    }

    @staticmethod
    def deploy_drone(player_data, drone_id, sector_id):
        # بررسی لول سندیکا (فقط لول ۲ به بالا)
        syn_data = player_data.get("syndicate_data", {})
        if syn_data.get("xp", 0) < 10000:
            return False, "Syndicate Level 2 required for Drone Ops."

        drone = BureauEngine.DRONE_TYPES.get(drone_id)
        if player_data.get("nsm_soft", 0) < drone["cost_nsm"]:
            return False, "Insufficient NSM Soft to fund drone deployment."

        player_data["nsm_soft"] -= drone["cost_nsm"]
        
        # ثبت پهپاد در دیتابیس بخش (ساده سازی شده)
        deployment = {
            "drone": drone["name"],
            "sector": sector_id,
            "active": True
        }
        
        return True, f"{drone['name']} deployed to Sector {sector_id}."
