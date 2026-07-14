class TreasuryEngine:
    # پارامترهای خزانه جهانی
    GLOBAL_STATS = {
        "total_shards_circulating": 542000, # شبیه‌سازی
        "reserve_gold": 10000000,
        "base_rate": 100 # ۱۰۰ شارد = ۱ توکن
    }

    @staticmethod
    def get_dynamic_rate():
        # منطق: هرچقدر شارد در گردش بیشتر باشد، نرخ تبدیل سخت‌تر می‌شود (تورم‌زدایی)
        supply = TreasuryEngine.GLOBAL_STATS["total_shards_circulating"]
        if supply > 1000000:
            return 120 # ۱۲۰ شارد برای ۱ توکن
        return 100

    @staticmethod
    def refine_shards(player_data, amount_shards):
        # هزینه تصفیه فوری: ۱۰۰۰ طلا به ازای هر ۱۰۰ شارد
        refine_cost = int((amount_shards / 100) * 1000)
        
        if player_data.get("gold", 0) < refine_cost:
            return False, f"Insufficient Gold. Need {refine_cost} to refine {amount_shards} shards."
        
        player_data["gold"] -= refine_cost
        # در اینجا وضعیت شاردها در دیتابیس به "REFINED" تغییر می‌کند
        return True, f"Successfully refined {amount_shards} shards. Ready for Instant Bridge."
