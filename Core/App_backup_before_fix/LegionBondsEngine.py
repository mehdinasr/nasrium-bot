class LegionBondsEngine:
    """ID_1025: سیستم مدیریت اوراق قرضه لژیونی برای جذب سرمایه."""
    # ساختار: {legion_name: {"available": int, "price": int, "dividend": float}}
    MARKET = {
        "ALPHA_LEGION": {"available": 1000, "price": 5000, "dividend": 0.02},
        "OMEGA_LEGION": {"available": 500, "price": 12000, "dividend": 0.05}
    }

    @staticmethod
    def purchase_bond(player_data, legion_name, count):
        bond = LegionBondsEngine.MARKET.get(legion_name)
        if not bond or bond["available"] < count:
            return False, "Insufficient bonds available in the market."
        
        total_cost = bond["price"] * count
        if player_data.get("intel_xp", 0) < total_cost:
            return False, "Insufficient IXP for this investment."
        
        player_data["intel_xp"] -= total_cost
        bond["available"] -= count
        
        # ثبت در سبد سرمایه‌گذاری بازیکن
        investments = player_data.get("bond_investments", {})
        investments[legion_name] = investments.get(legion_name, 0) + count
        player_data["bond_investments"] = investments
        
        return True, f"Successfully acquired {count} bonds of {legion_name}."
