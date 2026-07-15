import time

class EmpireDeepLogic:
    @staticmethod
    def distribute_pension(all_players, total_revenue):
        """ID_1015: واریز واقعی مستمری به حساب شهروندان."""
        for p in all_players:
            share = (p.get("honor_score", 0) / 1000000) * (total_revenue * 0.1)
            p["intel_xp"] += share
        return True

    @staticmethod
    def process_second_airdrop(all_players):
        """ID_1020: اجرای واقعی ایردراپ مرحله دوم."""
        count = 0
        for p in all_players:
            if p.get("nsm_tokens", 0) > 10:
                p["nsm_tokens"] += p["nsm_tokens"] * 0.05
                count += 1
        return count
