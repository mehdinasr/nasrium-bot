import random

class SimEngine:
    @staticmethod
    def run_simulation(attacker_data, target_data):
        # دریافت قدرت‌های پایه
        att_power = attacker_data.get("troops", 0)
        def_power = target_data.get("troops", 0) + (target_data.get("buildings", {}).get("cyber_wall", 0) * 50)
        
        # تاثیر تجهیزات و قهرمان (ساده‌سازی شده)
        if attacker_data.get("active_hero"):
            att_power *= 1.10
            
        success_count = 0
        for _ in range(100):
            # شبیه‌سازی ۱۰۰ نبرد با واریانس ۱۰ درصدی
            a_roll = att_power * random.uniform(0.9, 1.1)
            t_roll = def_power * random.uniform(0.9, 1.1)
            if a_roll > t_roll:
                success_count += 1
        
        return {
            "win_probability": success_count,
            "estimated_losses": int(attacker_data.get("troops", 0) * 0.15),
            "recommendation": "High risk" if success_count < 50 else "Optimal strike conditions"
        }
