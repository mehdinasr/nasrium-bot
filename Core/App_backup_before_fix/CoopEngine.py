class CoopEngine:
    # تعریف اهداف گروهی اتحاد
    ALLIANCE_GOALS = {
        "g1": {"desc": "Imperial Raid: Loot 500k Gold as a team", "target": 500000, "reward": 2000},
        "g2": {"desc": "Strength in Numbers: Train 1000 Soldiers", "target": 100, "reward": 3000}
    }

    @staticmethod
    def get_syn_progress(db, syn_name):
        syn = db.syndicates.find_one({"name": syn_name})
        if not syn: return {}
        
        # در نسخه پیشرفته، مجموع فعالیت اعضا از تراکنش‌ها استخراج می‌شود
        # فعلاً از فیلد total_donated به عنوان معیار پیشرفت استفاده می‌کنیم
        donated = syn.get("total_donated", 0)
        
        goals = []
        for gid, info in CoopEngine.ALLIANCE_GOALS.items():
            progress = min(100, int((donated / info["target"]) * 100))
            goals.append({
                "id": gid,
                "desc": info["desc"],
                "progress": progress,
                "reward": info["reward"],
                "completed": progress >= 100
            })
        return goals
