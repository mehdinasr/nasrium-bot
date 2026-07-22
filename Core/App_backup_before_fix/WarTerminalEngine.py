class WarTerminalEngine:
    @staticmethod
    def calculate_influence(syndicate_data, members_data):
        total_member_lvls = sum([m.get('town_hall_level', 1) for m in members_data])
        total_wins = sum([m.get('raid_wins', 0) for m in members_data])
        vault_gold = syndicate_data.get('vault_gold', 0)
        base_influence = (total_member_lvls * 100) + (vault_gold / 10) + (total_wins * 50)
        boost_mult = syndicate_data.get('influence_boost', 1.0)
        return int(base_influence * boost_mult)
