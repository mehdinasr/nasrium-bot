import random

class WormholeEngine:
    GATEWAY_REGISTRY = {}

    @staticmethod
    def initialize_gateway(player_id):
        WormholeEngine.GATEWAY_REGISTRY[player_id] = {
            "stability": 100,
            "cooldown_active": False,
            "total_extracted_gold": 0
        }
        return True, WormholeEngine.GATEWAY_REGISTRY[player_id]

    @staticmethod
    def extract_resources(player_id, raw_quantum_mass):
        if player_id not in WormholeEngine.GATEWAY_REGISTRY:
            WormholeEngine.initialize_gateway(player_id)
            
        gate = WormholeEngine.GATEWAY_REGISTRY[player_id]
        
        if gate["stability"] < 20:
            return False, "Wormhole is too unstable! Collapse imminent. Stabilize first."
            
        # شبیه‌سازی ریسک فضا-زمان (بین 5 تا 15 درصد احتمال نشت جرم)
        leakage_rate = random.uniform(0.05, 0.15)
        net_extraction = int(raw_quantum_mass * (1 - leakage_rate))
        
        # کاهش پایداری پورتال با هر بار استخراج
        gate["stability"] = max(10, gate["stability"] - random.randint(15, 25))
        gate["total_extracted_gold"] += net_extraction
        
        return True, {
            "extracted": net_extraction,
            "current_stability": gate["stability"],
            "leakage_percent": round(leakage_rate * 100, 2)
        }

    @staticmethod
    def stabilize_core(player_id):
        if player_id in WormholeEngine.GATEWAY_REGISTRY:
            WormholeEngine.GATEWAY_REGISTRY[player_id]["stability"] = 100
            return True, "Quantum core synchronized. Stability restored to 100%."
        return False, "Gateway not initialized."
