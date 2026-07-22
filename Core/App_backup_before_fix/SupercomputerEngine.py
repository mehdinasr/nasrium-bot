class SupercomputerEngine:
    # وضعیت پروژه جاری ابررایانه
    GLOBAL_PROJECT = {
        "name": "Project Singularity",
        "total_required": 1000000, # Neural Power units
        "current_contributed": 450000,
        "active_nodes": 1250,
        "reward_pool": "Global Energy Recovery +10%"
    }

    @staticmethod
    def calculate_contribution(player_data):
        # توان پردازشی بر اساس لول دستیار و نودهای پردازشی
        ai_lvl = sum(player_data.get("ai_evolution", {}).values())
        infra_lvl = sum(player_data.get("infrastructure", {}).values())
        return (ai_lvl * 10) + (infra_lvl * 5)

    @staticmethod
    def contribute_power(player_data):
        if not player_data.get("active_agent"):
            return False, "Active AI Agent required for Grid connection."
        
        power = SupercomputerEngine.calculate_contribution(player_data)
        SupercomputerEngine.GLOBAL_PROJECT["current_contributed"] += power
        SupercomputerEngine.GLOBAL_PROJECT["active_nodes"] += 1
        
        # ثبت پاداش افتخار برای بازیکن
        player_data["honor_score"] = player_data.get("honor_score", 0) + int(power / 5)
        return True, f"Synchronized with Central Core. Contributed {power} Neural Power."
