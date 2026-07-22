class PhysicalPaymentGateway:
    """ID_1906: درگاه نهایی برای خرید کالاهای فیزیکی با NSM."""
    @staticmethod
    def authorize_pos_transaction(u_id, amount):
        return f"TX_AUTHORIZED_FOR_{u_id}_TOTAL_{amount}_NSM"

class MerchantLicenseCore:
    """ID_1910: صدور مجوزهای بازرگانی برای نخبگان جهت فعالیت در بازار آزاد."""
    @staticmethod
    def verify_license(u_id):
        return True
