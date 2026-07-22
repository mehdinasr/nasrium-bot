class StrategyEngine:
    @staticmethod
    def analyze_raid(att_power, def_power):
        # محاسبه احتمال پیروزی
        win_chance = (att_power / (att_power + def_power)) * 100 if (att_power + def_power) > 0 else 0
        
        if win_chance > 80:
            risk = "Low - Total Domination Expected"
            advice = "Crush them without hesitation, Commander."
        elif win_chance > 50:
            risk = "Medium - Victory is likely but losses will occur"
            advice = "A fair fight. Fortune favors the bold."
        else:
            risk = "High - High probability of defeat"
            advice = "Retreat! This is a suicide mission. Train more troops first."
            
        return {
            "win_chance": round(win_chance, 1),
            "risk_level": risk,
            "advice": advice
        }
