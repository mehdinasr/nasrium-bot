class DividendEngine:
    # درصد سودی که از کل مالیات‌های شبکه به بازیکنان می‌رسد
    DISTRIBUTION_RATE = 0.10 

    @staticmethod
    def calculate_share(player_data, global_pool):
        # سهم بازیکن = (مقدار استیک شده بازیکن / کل استیک جهان) * استخر سود
        vault = player_data.get("vault", {})
        staked_amt = vault.get("staked", 0)
        
        if staked_amt <= 0:
            return 0
            
        # شبیه‌سازی: نرخ سود بر اساس مقدار استیک (مثلاً ۱٪ مبلغ استیک در هر دوره)
        share = staked_amt * 0.01 
        return round(share, 2)

    @staticmethod
    def process_dividend_claim(player_data):
        share = player_data.get("pending_dividends", 0)
        if share <= 0:
            return False, "No dividends available for synchronization."
        
        player_data["nsm_soft"] += share
        player_data["pending_dividends"] = 0
        return True, f"Imperial Dividend of {share} NSM received."
