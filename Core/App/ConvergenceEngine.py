class ConvergenceEngine:
    @staticmethod
    def calculate_final_pool(player_data):
        from Core.App.DistributionEngine import DistributionEngine
        from Core.App.PrestigeEngine import PrestigeEngine
        
        # ۱. دریافت تخصیص پایه (بر اساس امتیاز افتخار و شاردها)
        base_blueprint = DistributionEngine.calculate_allocation(player_data)
        base_nsm = base_blueprint["total_nsm"]
        
        # ۲. دریافت ضریب وفاداری
        loyalty_data = PrestigeEngine.calculate_loyalty_multiplier(player_data)
        multiplier = loyalty_data["multiplier"]
        
        # ۳. محاسبه نهایی
        final_total = int(base_nsm * multiplier)
        tge_unlock = int(final_total * 0.25)
        
        return {
            "base_allocation": base_nsm,
            "loyalty_multiplier": multiplier,
            "final_nsm_hard": final_total,
            "immediate_unlock": tge_unlock,
            "loyalty_tier": loyalty_data["tier"]
        }
