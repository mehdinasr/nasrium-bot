class SovereignCouncil:
    """CMD_960: مدیریت انتخابات شورای عالی نصریوم."""
    CANDIDATES = [] # لیست کاندیداها (فقط لول ۸)
    VOTES = {} # {candidate_id: vote_count}

    @staticmethod
    def register_candidate(u_id, rank):
        if rank == "Sovereign" and u_id not in SovereignCouncil.CANDIDATES:
            SovereignCouncil.CANDIDATES.append(u_id)
            SovereignCouncil.VOTES[u_id] = 0
            return True, "Candidacy accepted for the Sovereign Council."
        return False, "Access denied. Only Sovereigns can lead."

class LegionFinanceV2:
    """CMD_961: سیستم مالیات خودکار لژیون‌ها برای تامین بودجه جنگی."""
    TAX_RATES = {} # {legion_name: tax_rate}

    @staticmethod
    def apply_tax(amount, legion_name):
        rate = LegionFinanceV2.TAX_RATES.get(legion_name, 0.05) # ۵٪ پیش‌فرض
        tax = amount * rate
        return amount - tax, tax

class ZenithMarket:
    """CMD_962: بازار فوق نایاب برای کدهای دسترسی سیستمی."""
    ZENITH_ITEMS = {
        "alpha_code": {"name": "Alpha Protocol Key", "price": 100000000, "desc": "Global Speed Boost 2x for 1h"},
        "void_seal": {"name": "Void Seal", "price": 500000000, "desc": "Protect Legion from all raids for 24h"}
    }
