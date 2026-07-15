class LegionBondsEngine:
    MARKET = {
        "ALPHA_LEGION": {"available": 1000, "price": 5000, "dividend": 0.02},
        "OMEGA_LEGION": {"available": 500, "price": 12000, "dividend": 0.05}
    }
    @staticmethod
    def purchase_bond(player_data, l_name, count):
        bond = LegionBondsEngine.MARKET.get(l_name)
        if not bond or bond["available"] < count: return False, "Market Shortage"
        cost = bond["price"] * count
        if player_data.get("intel_xp", 0) < cost: return False, "Low IXP"
        player_data["intel_xp"] -= cost
        bond["available"] -= count
        invest = player_data.get("bond_investments", {})
        invest[l_name] = invest.get(l_name, 0) + count
        player_data["bond_investments"] = invest
        return True, "Bond Acquired"

class LunarRealEstate:
    LAND_PLOTS = {f"PLOT_{i}": {"owner": "None", "price": 1000} for i in range(1, 11)}
