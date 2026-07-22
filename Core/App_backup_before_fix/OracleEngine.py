class OracleEngine:
    BASE_RATE = 1000 # نرخ پایه

    @staticmethod
    def get_world_liquidity(db):
        # محاسبه مجموع طلای موجود در کل امپراتوری
        pipeline = [{"$group": {"_id": None, "total": {"$sum": "$gold"}}}]
        result = list(db.players.aggregate(pipeline))
        return result[0]["total"] if result else 0

    @staticmethod
    def calculate_dynamic_rate(db):
        total_gold = OracleEngine.get_world_liquidity(db)
        total_users = db.players.count_documents({})
        if total_users == 0: return OracleEngine.BASE_RATE
        
        # فرمول: نرخ پایه + (میانگین طلا به ازای هر نفر / 10)
        avg_gold = total_gold / total_users
        dynamic_rate = int(OracleEngine.BASE_RATE + (avg_gold / 10))
        return max(OracleEngine.BASE_RATE, dynamic_rate)
