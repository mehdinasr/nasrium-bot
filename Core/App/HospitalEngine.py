class HospitalEngine:
    # ضریب هزینه احیا (۳۰٪ هزینه آموزش اصلی)
    RECOVERY_COST_FACTOR = 0.3
    # ضریب بازگشت نیرو (حداکثر ۴۰٪ تلفات قابل بازگشت است)
    RECOVERY_RATE = 0.4

    @staticmethod
    def get_recoverable_troops(player_data):
        last_losses = player_data.get("last_battle_losses", {})
        recoverable = {}
        for u_type, count in last_losses.items():
            recoverable[u_type] = int(count * HospitalEngine.RECOVERY_RATE)
        return recoverable

    @staticmethod
    def calculate_recovery_gold_cost(recoverable_dict):
        from Core.App.TroopEngine import TroopEngine
        total_cost = 0
        for u_type, count in recoverable_dict.items():
            base_cost = TroopEngine.UNIT_TYPES.get(u_type, {}).get("cost", 500)
            total_cost += int(count * base_cost * HospitalEngine.RECOVERY_COST_FACTOR)
        return total_cost
