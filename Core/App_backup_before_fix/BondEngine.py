import time

class BondEngine:
    # لیست اوراق فعال {bond_id: {issuer, total_value, interest, duration, sold_amount}}
    ACTIVE_BONDS = {}

    @staticmethod
    def issue_bond(fed_id, volume, interest_rate, days):
        bond_id = f"BOND-{fed_id}-{int(time.time())}"
        BondEngine.ACTIVE_BONDS[bond_id] = {
            "issuer": fed_id,
            "volume": volume,
            "interest": interest_rate,
            "term": days * 86400,
            "sold": 0,
            "created_at": time.time()
        }
        return True, f"Imperial Bond {bond_id} issued to the market."

    @staticmethod
    def buy_bond(player_data, bond_id, amount):
        bond = BondEngine.ACTIVE_BONDS.get(bond_id)
        if not bond: return False, "Bond not found or expired."
        
        if bond["sold"] + amount > bond["volume"]:
            return False, "Not enough bond units remaining."

        if player_data.get("nsm_soft", 0) < amount:
            return False, "Insufficient NSM Soft for this investment."

        player_data["nsm_soft"] -= amount
        bond["sold"] += amount
        
        # ثبت در پورتفوی بازیکن
        investment = {
            "bond_id": bond_id,
            "principal": amount,
            "payout": int(amount * (1 + bond["interest"])),
            "maturity": time.time() + bond["term"]
        }
        
        portfolio = player_data.get("bond_portfolio", [])
        portfolio.append(investment)
        player_data["bond_portfolio"] = portfolio
        
        return True, f"Investment Confirmed. You acquired {amount} units of {bond_id}."
