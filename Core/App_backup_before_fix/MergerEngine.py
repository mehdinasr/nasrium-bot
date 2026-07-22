class MergerEngine:
    # هزینه‌های رسمی ادغام
    MERGER_COST = {"gold": 500000, "nsm_hard": 100}

    @staticmethod
    def process_merger(lead_syn_data, target_syn_data):
        # یکپارچه‌سازی منابع و تجربه
        lead_syn_data["xp"] += int(target_syn_data.get("xp", 0) * 0.8) # ۲۰٪ افت در انتقال تجربه
        lead_syn_data["war_chest_nsm"] += target_syn_data.get("war_chest_nsm", 0)
        
        # انتقال اعضا (ساده‌سازی شده)
        new_members = lead_syn_data.get("members", []) + target_syn_data.get("members", [])
        lead_syn_data["members"] = list(set(new_members))
        
        return True, f"Unification Complete: {target_syn_data['name']} has been absorbed."
