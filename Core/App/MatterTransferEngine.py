class MatterTransferEngine:
    """ID_1028: مدیریت انتقال آنی منابع بین شهروندان و لژیون ها."""
    @staticmethod
    def transfer_ixp(sender_data, receiver_data, amount):
        if sender_data.get("intel_xp", 0) < amount:
            return False, "Insufficient resources for molecular reconstruction."
        
        # کارمزد انتقال ماده (Molecular Tax) - 2%
        tax = amount * 0.02
        transfer_amount = amount - tax
        
        sender_data["intel_xp"] -= amount
        receiver_data["intel_xp"] += transfer_amount
        
        return True, f"Transfer successful. {transfer_amount} IXP materialized at destination."
