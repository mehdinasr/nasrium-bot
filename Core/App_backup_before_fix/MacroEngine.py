class MacroEngine:
    @staticmethod
    def calculate_global_metrics(all_players):
        total_gold = sum([p.get("gold", 0) for p in all_players])
        total_nsm = sum([p.get("nsm_soft", 0) for p in all_players])
        total_nfts = sum([len(p.get("minted_nfts", [])) for p in all_players])
        total_citizens = len(all_players)
        
        # محاسبه شاخص پایداری امپراتوری (فرمول فرضی)
        # پایداری بیشتر = نسبت توکن به طلا متعادل‌تر
        stability = 100 - min(40, (total_gold / 1000000))
        
        return {
            "gold_supply": total_gold,
            "nsm_supply": total_nsm,
            "nft_count": total_nfts,
            "active_commanders": total_citizens,
            "stability_index": int(stability)
        }
