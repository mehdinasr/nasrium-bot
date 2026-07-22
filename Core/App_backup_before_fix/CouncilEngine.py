class CouncilEngine:
    @staticmethod
    def get_strategic_advice(player_data, market_data):
        gold = player_data.get("gold", 0)
        energy = player_data.get("energy", 0)
        troops = player_data.get("troops", 0)
        th_lvl = player_data.get("town_hall_level", 1)
        market_mult = market_data.get("multiplier", 1.0)
        
        advice = []
        if gold > 50000 and market_mult > 0.9:
            advice.append({"area": "Economy", "msg": "Market stable. Invest in upgrades."})
        elif gold < 10000:
            advice.append({"area": "Economy", "msg": "Treasury low. Launch a Heist."})
            
        if troops < (th_lvl * 10):
            advice.append({"area": "Military", "msg": "Defenses thin. Recruit more units."})
        elif energy > 80:
            advice.append({"area": "Military", "msg": "Energy high. Launch a PvP Raid."})
            
        return advice if advice else [{"area": "General", "msg": "All systems nominal."}]
