class LegionEngine:
    """
    مدیریت کلن‌ها و گروه‌های نظامی نصریوم.
    """
    LEGIONS = {} # {legion_name: {leader: u_id, members: [], treasury: 0}}
    CREATION_COST = 50000 # هزینه سنگین برای جلوگیری از ایجاد لژیون‌های اسپم

    @staticmethod
    def create_legion(u_id, player_data, legion_name):
        if player_data.get("intel_xp", 0) < LegionEngine.CREATION_COST:
            return False, f"Need {LegionEngine.CREATION_COST} IXP to form a Legion."
        
        if legion_name in LegionEngine.LEGIONS:
            return False, "Legion name already exists in the Imperial Archives."

        player_data["intel_xp"] -= LegionEngine.CREATION_COST
        player_data["legion"] = legion_name
        
        LegionEngine.LEGIONS[legion_name] = {
            "leader": u_id,
            "members": [u_id],
            "treasury": 0,
            "power": player_data.get("intel_xp", 0)
        }
        return True, f"Legion '{legion_name}' has been founded."

    @staticmethod
    def join_legion(u_id, player_data, legion_name):
        if legion_name not in LegionEngine.LEGIONS:
            return False, "Legion not found."
        
        if player_data.get("legion"):
            return False, "You are already bound to another Legion."

        LegionEngine.LEGIONS[legion_name]["members"].append(u_id)
        player_data["legion"] = legion_name
        return True, f"You have joined the ranks of {legion_name}."

    @staticmethod
    def get_all_legions():
        return LegionEngine.LEGIONS
