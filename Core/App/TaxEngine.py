class TaxEngine:
    # دیتای خزانه‌های فدراسیون {fed_id: {balance, tax_rate, projects}}
    FED_TREASURIES = {}

    @staticmethod
    def collect_tax(fed_id, amount):
        if fed_id not in TaxEngine.FED_TREASURIES:
            TaxEngine.FED_TREASURIES[fed_id] = {"balance": 0, "tax_rate": 0.02, "projects": []}
        
        treasury = TaxEngine.FED_TREASURIES[fed_id]
        tax_amount = int(amount * treasury["tax_rate"])
        treasury["balance"] += tax_amount
        return tax_amount

    @staticmethod
    def set_tax_rate(fed_id, new_rate):
        # نرخ مالیات نباید از ۵٪ بیشتر شود
        if new_rate > 0.05: return False, "Tax rate exceeds Federal Limit (5%)."
        
        if fed_id in TaxEngine.FED_TREASURIES:
            TaxEngine.FED_TREASURIES[fed_id]["tax_rate"] = new_rate
            return True, f"Tax rate set to {new_rate * 100}%."
        return False, "Federation treasury not initialized."
