class TreasuryEngine:
    """
    مدیریت خزانه مرکزی نصریوم و توزیع رفاه.
    """
    IMPERIAL_VAULT = 0
    TAX_RATE = 0.02  # 2% مالیات بر درآمدهای بزرگ
    WELFARE_THRESHOLD = 1000  # شهروندان زیر این مقدار IXP واجد شرایط رفاه هستند

    @staticmethod
    def collect_tax(amount):
        tax = amount * TreasuryEngine.TAX_RATE
        TreasuryEngine.IMPERIAL_VAULT += tax
        return amount - tax

    @staticmethod
    def claim_welfare(player_data):
        if player_data.get("intel_xp", 0) < TreasuryEngine.WELFARE_THRESHOLD:
            grant = 200
            if TreasuryEngine.IMPERIAL_VAULT >= grant:
                TreasuryEngine.IMPERIAL_VAULT -= grant
                player_data["intel_xp"] += grant
                return True, f"Welfare Grant of {grant} IXP issued from the Treasury."
        return False, "Not eligible for welfare or Treasury funds low."

    @staticmethod
    def get_vault_balance():
        return TreasuryEngine.IMPERIAL_VAULT
