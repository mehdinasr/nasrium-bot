import time

class SyndicateWarEngine:
    # هزینه اعلان جنگ جهانی
    WAR_DECLARATION_COST = 10000

    @staticmethod
    def declare_war(attacker_syn_name, target_syn_name, player_data):
        if player_data.get("nsm_soft", 0) < SyndicateWarEngine.WAR_DECLARATION_COST:
            return False, "Insufficient NSM Soft to declare war."
        
        # ثبت وضعیت جنگ (در دیتابیس سندیکاها ذخیره خواهد شد)
        war_data = {
            "attacker": attacker_syn_name,
            "defender": target_syn_name,
            "ends_at": time.time() + 86400, # ۲۴ ساعت
            "attacker_score": 0,
            "defender_score": 0
        }
        
        player_data["nsm_soft"] -= SyndicateWarEngine.WAR_DECLARATION_COST
        return True, f"War declared on {target_syn_name}! The frontline is active."

    @staticmethod
    def calculate_contribution(player_data):
        # قدرت مشارکت بازیکن در جنگ بر اساس GPI او
        from Core.App.RankingEngine import RankingEngine
        return RankingEngine.calculate_power_score(player_data)
