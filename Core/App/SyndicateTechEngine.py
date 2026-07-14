class SyndicateTechEngine:
    # تعریف پروژه‌های تحقیقاتی اتحاد
    TECH_PROJECTS = {
        "reinforced_plating": {"name": "Reinforced Plating", "target_nsm": 50000, "desc": "+5% Building Durability"},
        "rapid_logistics": {"name": "Rapid Logistics", "target_nsm": 30000, "desc": "-10% Energy Recovery Time"},
        "heavy_rounds": {"name": "Heavy Rounds", "target_nsm": 100000, "desc": "+5% Attack Power"}
    }

    @staticmethod
    def get_tech_status(db, syn_name):
        syn = db.syndicates.find_one({"name": syn_name})
        if not syn: return []
        
        tech_progress = syn.get("tech_progress", {})
        status_list = []
        for tid, info in SyndicateTechEngine.TECH_PROJECTS.items():
            invested = tech_progress.get(tid, 0)
            percent = min(100, int((invested / info["target_nsm"]) * 100))
            status_list.append({
                "id": tid,
                "name": info["name"],
                "progress": percent,
                "target": info["target_nsm"],
                "invested": invested,
                "desc": info["desc"]
            })
        return status_list

    @staticmethod
    def contribute_to_tech(db, player_data, tech_id, amount):
        if player_data.get("nsm_soft", 0) < amount:
            return False, "Insufficient NSM Soft."
        
        syn_name = player_data.get("syndicate")
        if not syn_name: return False, "No Syndicate found."

        # کسر از بازیکن
        db.players.update_one({"user_id": player_data["user_id"]}, {"$inc": {"nsm_soft": -amount}})
        
        # اضافه به پروژه تحقیق اتحاد
        field = f"tech_progress.{tech_id}"
        db.syndicates.update_one({"name": syn_name}, {"$inc": {field: amount}})
        
        return True, f"Contributed {amount} NSM to {tech_id} project!"
