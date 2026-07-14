class OrbitalEngine:
    """CMD_941: نبردهای مداری برای تسخیر ماهواره‌های استخراج."""
    SATELLITES = {
        "SAT_ALPHA": {"owner": "None", "boost": 0.15, "min_bid": 500000},
        "SAT_BETA":  {"owner": "None", "boost": 0.25, "min_bid": 1000000}
    }

    @staticmethod
    def capture_satellite(l_name, sat_id, bid_amount):
        sat = OrbitalEngine.SATELLITES.get(sat_id)
        if bid_amount >= sat["min_bid"]:
            sat["owner"] = l_name
            sat["min_bid"] = bid_amount + 100000
            return True, f"Legion {l_name} now controls {sat_id}. +{int(sat['boost']*100)}% Global Mining Boost for members."
        return False, "Bid too low to disrupt current orbit."

class TokenMintingEngine:
    """CMD_942: تبدیل IXP به توکن‌های حاکمیتی NSM (Nasrium Sovereign Money)."""
    MINT_RATE = 1000000 # هر ۱ میلیون IXP = ۱ توکن NSM

    @staticmethod
    def mint_sovereign_tokens(player_data, ixp_amount):
        if player_data.get("intel_xp", 0) < ixp_amount:
            return False, "Not enough IXP in the core."
        
        tokens = ixp_amount / TokenMintingEngine.MINT_RATE
        player_data["intel_xp"] -= ixp_amount
        player_data["nsm_tokens"] = player_data.get("nsm_tokens", 0) + tokens
        return True, f"Successfully minted {tokens} NSM tokens."

class DefenseMinigame:
    """CMD_943: مینی‌گیم شکارچیان ویروس برای حفاظت از استخر منابع."""
    @staticmethod
    def trigger_attack():
        import random
        return {"virus_strength": random.randint(1, 5), "sector": random.choice(["Alpha", "Gamma", "Omega"])}
