class DecreeEngine:
    # قوانین فعال که توسط مجلس سنا (CMD_348) تصویب شده اند
    ACTIVE_DECREES = {
        "gold_boost": {"active": True, "mult": 1.20, "desc": "Gold Rush Protocol (+20%)"},
        "energy_save": {"active": False, "mult": 0.90, "desc": "Energy Efficiency (-10%)"},
        "war_tax": {"active": True, "mult": 1.10, "desc": "Imperial War Tax (+10% Loot)"}
    }

    @staticmethod
    def get_multiplier(decree_id):
        decree = DecreeEngine.ACTIVE_DECREES.get(decree_id)
        if decree and decree["active"]:
            return decree["mult"]
        return 1.0

    @staticmethod
    def get_active_constitution():
        return [d["desc"] for d in DecreeEngine.ACTIVE_DECREES.values() if d["active"]]
