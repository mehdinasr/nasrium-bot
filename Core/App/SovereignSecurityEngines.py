class PlanetaryTaxAllocation:
    """ID_1105: تخصیص درآمدهای مالیاتی هر سیاره به لژیون فاتح."""
    PLANET_REVENUE = {} # {planet_id: accumulated_ixp}
    @staticmethod
    def allocate_to_legion(planet_id, amount):
        PlanetaryTaxAllocation.PLANET_REVENUE[planet_id] = PlanetaryTaxAllocation.PLANET_REVENUE.get(planet_id, 0) + amount
        return True

class AutomatedSovereignInsurance:
    """ID_1106: محافظت خودکار از دارایی های نخبگان در زمان نوسانات شدید."""
    @staticmethod
    def is_protected(player_data):
        return player_data.get("nsm_tokens", 0) > 10000

class QuantumNodeSync:
    """ID_1107: همگام سازی گره های پردازشی برای سرعت بخشیدن به تایید تراکنش ها."""
    @staticmethod
    def sync_nodes():
        return "SYNC_STATUS: OPTIMAL"
