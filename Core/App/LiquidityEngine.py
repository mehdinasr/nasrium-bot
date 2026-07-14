class LiquidityEngine:
    """CMD_953: مدیریت استخرهای سرمایه‌گذاری لژیون‌ها."""
    POOLS = {} # {legion_name: {"total_staked": 0, "investors": {}}}

    @staticmethod
    def contribute_to_pool(l_name, u_id, amount, player_data):
        if player_data.get("intel_xp", 0) < amount:
            return False, "Insufficient IXP for investment."
        
        if l_name not in LiquidityEngine.POOLS:
            LiquidityEngine.POOLS[l_name] = {"total_staked": 0, "investors": {}}
        
        player_data["intel_xp"] -= amount
        LiquidityEngine.POOLS[l_name]["total_staked"] += amount
        LiquidityEngine.POOLS[l_name]["investors"][u_id] = LiquidityEngine.POOLS[l_name]["investors"].get(u_id, 0) + amount
        
        return True, f"Contribution of {amount} IXP to {l_name} pool successful."

    @staticmethod
    def get_pool_status(l_name):
        return LiquidityEngine.POOLS.get(l_name, {"total_staked": 0, "investors": {}})
