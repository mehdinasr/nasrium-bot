class DistributionEngine:
    @staticmethod
    def calculate_allocation(player_data):
        from Core.App.ChronicleEngine import ChronicleEngine
        
        # ۱. محاسبه امتیازات پایه
        honor = ChronicleEngine.calculate_total_honor(player_data)
        staked = player_data.get("vault", {}).get("staked", 0)
        nfts = len(player_data.get("minted_nfts", []))
        
        # ۲. فرمول تخصیص نهایی (نمونه)
        # هر ۱۰۰ امتیاز افتخار = ۱۰ توکن
        # هر ۱۰۰۰ توکن استیک شده = ۵۰ توکن پاداش
        # هر NFT = ۱۰۰ توکن پاداش
        
        total_allocation = (honor / 10) + (staked * 0.05) + (nfts * 100)
        
        # ۳. محاسبه وستینگ (Vesting)
        tge_unlock = total_allocation * 0.25 # ۲۵ درصد آزادسازی آنی
        monthly_vesting = (total_allocation * 0.75) / 3 # آزادسازی طی ۳ ماه
        
        return {
            "total_nsm": int(total_allocation),
            "tge_unlock": int(tge_unlock),
            "vesting_plan": "3 Months Linear",
            "monthly_amount": int(monthly_vesting)
        }
