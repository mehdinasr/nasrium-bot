class SyndicateEngine:
    @staticmethod
    def create_syndicate(player_data, syn_name):
        # بررسی وضعیت فعلی بازیکن
        if player_data.get("syndicate") and player_data.get("syndicate") != "None":
            return False, "Already in a syndicate."
        if len(syn_name) < 3 or len(syn_name) > 15:
            return False, "Name must be 3-15 characters."
        
        # هزینه تاسیس سندیکا: 50,000 طلا
        if player_data.get("gold", 0) < 50000:
            return False, "Need 50,000 Gold to form a syndicate."
        
        player_data["gold"] -= 50000
        new_syn_meta = {
            "name": syn_name,
            "leader": player_data["user_id"],
            "vault_gold": 0,
            "level": 1,
            "members": [player_data["user_id"]]
        }
        player_data["syndicate"] = syn_name
        return True, new_syn_meta

    @staticmethod
    def get_tax_contribution(loot_amount):
        # قانون مالیات سندیکا: 5% از هر غارت به خزانه واریز می شود
        return int(loot_amount * 0.05)
