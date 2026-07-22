class SynTreasuryEngine:
    @staticmethod
    def calculate_sector_revenue(controlled_sectors_count):
        return controlled_sectors_count * 1000

    @staticmethod
    def distribute_rewards(syn_data, member_list):
        total_pool = syn_data.get("war_chest", 0)
        if total_pool <= 0 or not member_list:
            return False, 0
        return True, int(total_pool / len(member_list))
