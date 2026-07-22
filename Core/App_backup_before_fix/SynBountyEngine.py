class SynBountyEngine:
    # لیست قراردادهای فعال {target_id: {issuing_syn, reward, status}}
    ACTIVE_CONTRACTS = {}

    @staticmethod
    def post_contract(syn_data, target_id, gold_amount):
        if syn_data.get("war_chest", 0) < gold_amount:
            return False, "Insufficient funds in Syndicate War Chest."
        
        # کسر از خزانه و ثبت قرارداد
        syn_data["war_chest"] -= gold_amount
        SynBountyEngine.ACTIVE_CONTRACTS[target_id] = {
            "issuing_syn": syn_data.get("name", "Unknown"),
            "reward": gold_amount,
            "status": "ACTIVE"
        }
        return True, f"War Contract authorized on {target_id}."

    @staticmethod
    def claim_contract(hunter_data, target_id):
        contract = SynBountyEngine.ACTIVE_CONTRACTS.get(target_id)
        if not contract: return 0
        
        reward = contract["reward"]
        # ۱۵٪ مالیات امپراتوری (Burn)
        tax = int(reward * 0.15)
        net_reward = reward - tax
        
        hunter_data["gold"] += net_reward
        del SynBountyEngine.ACTIVE_CONTRACTS[target_id]
        return net_reward
