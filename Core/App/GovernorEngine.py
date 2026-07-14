class GovernorEngine:
    # حد آستانه نقدینگی برای شروع کنترل تورم (مثلا ۵ میلیون طلا)
    INFLATION_THRESHOLD = 5000000 

    @staticmethod
    def calculate_market_multiplier(db):
        from Core.App.OracleEngine import OracleEngine
        total_gold = OracleEngine.get_world_liquidity(db)
        
        if total_gold <= GovernorEngine.INFLATION_THRESHOLD:
            return 1.0, "Stable"
        
        # فرمول کاهش راندمان: هر ۱ میلیون طلا مازاد، ۵٪ کاهش تولید (حداکثر تا ۵۰٪)
        excess = (total_gold - GovernorEngine.INFLATION_THRESHOLD) / 1000000
        multiplier = max(0.5, 1.0 - (excess * 0.05))
        
        status = "Inflationary" if multiplier < 0.9 else "Warning"
        return round(multiplier, 2), status
