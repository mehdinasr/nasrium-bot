class UnionEngine:
    """
    مدیریت پیوندهای عصبی و ازدواج‌های دیجیتال در نصریوم.
    """
    UNION_COST = 20000 # هزینه برقراری پیوند
    PENDING_PROPOSALS = {} # {partner_id: proposer_id}

    @staticmethod
    def propose_union(proposer_id, partner_id, proposer_data):
        if proposer_data.get("intel_xp", 0) < UnionEngine.UNION_COST:
            return False, f"You need {UnionEngine.UNION_COST} IXP to initiate a Neural Union."
        
        if proposer_data.get("union_partner"):
            return False, "Your core is already synchronized with another."

        UnionEngine.PENDING_PROPOSALS[partner_id] = proposer_id
        return True, f"Neural Link request sent to Citizen {partner_id}."

    @staticmethod
    def accept_union(partner_id, partner_data, proposer_data):
        proposer_id = UnionEngine.PENDING_PROPOSALS.get(partner_id)
        if not proposer_id:
            return False, "No pending proposals found for your core."

        # برقراری پیوند
        partner_data["union_partner"] = proposer_id
        proposer_data["union_partner"] = partner_id
        
        # کسر هزینه از پیشنهاددهنده
        proposer_data["intel_xp"] -= UnionEngine.UNION_COST
        
        # اعمال بوف‌های دائمی (نمادین در دیتای بازیکن)
        partner_data["mining_boost"] = partner_data.get("mining_boost", 1.0) + 0.05
        proposer_data["mining_boost"] = proposer_data.get("mining_boost", 1.0) + 0.05
        
        del UnionEngine.PENDING_PROPOSALS[partner_id]
        return True, "Neural Union Established. Two cores are now one."
