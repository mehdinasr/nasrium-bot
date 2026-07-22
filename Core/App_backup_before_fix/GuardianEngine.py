class GuardianEngine:
    # وضعیت زنده باس‌ها (در سیستم واقعی در DB ذخیره می‌شود)
    BOSSES = {
        "obsidian_golem": {"name": "Obsidian Golem", "hp": 1000000, "max_hp": 1000000, "reward": 50000},
        "void_serpent": {"name": "Void Serpent", "hp": 5000000, "max_hp": 5000000, "reward": 250000}
    }

    @staticmethod
    def assault(player_data, boss_id):
        boss = GuardianEngine.BOSSES.get(boss_id)
        if not boss: return False, "Guardian not found in this sector."
        if boss["hp"] <= 0: return False, "Guardian is already shattered."

        # هزینه حمله: ۲۰ انرژی
        if player_data.get("energy", 0) < 20:
            return False, "Insufficient energy for such a heavy assault."

        # محاسبه آسیب (بر اساس قدرت نظامی بازیکن)
        damage = player_data.get("troops", 0) * 2
        boss["hp"] -= damage
        player_data["energy"] -= 20
        
        if boss["hp"] < 0: boss["hp"] = 0
        
        # ثبت سهم بازیکن در غارت (در صورت شکست باس)
        return True, f"Direct Hit! Dealt {damage} damage to {boss['name']}."
