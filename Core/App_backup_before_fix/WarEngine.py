import time

class WarEngine:
    @staticmethod
    def get_war_pool(db):
        pool = db.world_state.find_one({"type": "war_pool"})
        if not pool:
            pool = {"type": "war_pool", "total_gold": 100000}
            db.world_state.insert_one(pool)
        return pool

    @staticmethod
    def execute_clash(db, war_id):
        from bson.objectid import ObjectId
        war = db.syndicate_wars.find_one({"_id": ObjectId(war_id)})
        if not war or war.get("status") != "ACTIVE":
            return False, "War is not active or already resolved."

        # محاسبه قدرت دو طرف
        from Core.App.SyndicateEngine import SyndicateEngine
        from Core.App.AssetEngine import AssetEngine

        def get_total_power(syn_name, power_type):
            members = list(db.players.find({"syndicate": syn_name}))
            total = 0
            for m in members:
                stats = AssetEngine.calculate_stats(m)
                total += stats[power_type]
            
            # اعمال بونوس سطح اتحاد
            syn_data = db.syndicates.find_one({"name": syn_name})
            buffs = SyndicateEngine.get_syndicate_buffs(syn_data)
            bonus = 1 + (buffs["atk_bonus"] / 100)
            return int(total * bonus)

        atk_power = get_total_power(war["attacker"], "attack_power")
        def_power = get_total_power(war["defender"], "defense_power")

        winner = war["attacker"] if atk_power > def_power else war["defender"]
        loser = war["defender"] if atk_power > def_power else war["attacker"]

        # توزیع جوایز از خزانه جهانی
        pool = WarEngine.get_war_pool(db)
        total_loot = int(pool["total_gold"] * 0.70)
        
        # تقسیم بین اعضای برنده
        winners = list(db.players.find({"syndicate": winner}))
        share = int(total_loot / len(winners)) if winners else 0
        for w in winners:
            db.players.update_one({"user_id": w["user_id"]}, {"$inc": {"gold": share}})
            from Core.App.PlayerRepository import PlayerRepository
            PlayerRepository.add_log(w["user_id"], f"WAR VICTORY! Your share of loot: {share} Gold.")

        # بروزرسانی وضعیت جهانی
        db.world_state.update_one({"type": "war_pool"}, {"$inc": {"total_gold": -total_loot}})
        db.syndicate_wars.update_one({"_id": ObjectId(war_id)}, {"$set": {"status": "RESOLVED", "winner": winner, "loot_distributed": total_loot}})

        return True, f"War Resolved! Winner: {winner}. Total Loot: {total_loot} Gold."
