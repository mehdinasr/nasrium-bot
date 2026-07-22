import time

class NeuralHubEngine:
    # پارامترهای تولید دانش (IXP)
    BASE_RATE = 10 # ۱۰ واحد IXP در ساعت به ازای هر لول
    UPGRADE_COST = {"gold": 200000, "scraps": 200}

    @staticmethod
    def calculate_yield(player_data):
        hub_lvl = player_data.get("neural_hub_lvl", 1)
        last_claim = player_data.get("last_ixp_claim", time.time())
        
        hours_passed = (time.time() - last_claim) / 3600
        yield_amount = int(hours_passed * NeuralHubEngine.BASE_RATE * hub_lvl)
        
        return yield_amount

    @staticmethod
    def claim_ixp(player_data):
        amount = NeuralHubEngine.calculate_yield(player_data)
        if amount <= 0: return False, "Neural circuits are still processing data..."

        player_data["intel_xp"] = player_data.get("intel_xp", 0) + amount
        player_data["last_ixp_claim"] = time.time()
        
        return True, f"Neural Synapse Claimed: +{amount} IXP injected into AI core."
