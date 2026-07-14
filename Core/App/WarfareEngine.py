class WarfareEngine:
    # تعریف انواع پروتکل های نفوذ
    PROTOCOLS = {
        "jamming": {"name": "Signal Jammer", "cost_nsm": 300, "energy": 10, "effect": "Radar Disable"},
        "virus": {"name": "Neural Virus", "cost_nsm": 600, "energy": 15, "effect": "-10% Defense"},
        "siphon": {"name": "Data Siphon", "cost_nsm": 1000, "energy": 25, "effect": "Steal Gold"}
    }

    @staticmethod
    def execute_strike(attacker_data, target_data, protocol_id):
        protocol = WarfareEngine.PROTOCOLS.get(protocol_id)
        if not protocol: return False, "Invalid Protocol."

        if attacker_data.get("nsm_soft", 0) < protocol["cost_nsm"]:
            return False, "Insufficient Digital Ammo (NSM Soft)."

        # اجرای عملیات نفوذ بر اساس نوع پروتکل
        attacker_data["nsm_soft"] -= protocol["cost_nsm"]
        
        if protocol_id == "siphon":
            stolen = int(target_data.get("gold", 0) * 0.02) # ۲ درصد طلا
            target_data["gold"] -= stolen
            attacker_data["gold"] += stolen
            return True, f"Breach Successful! Siphoned {stolen} Gold."
        
        return True, f"Protocol {protocol['name']} successfully uploaded to target."
