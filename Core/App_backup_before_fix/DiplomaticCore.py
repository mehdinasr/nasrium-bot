class DiplomaticCore:
    """
    مدیریت روابط خارجی و سیستم سفیران نصریوم.
    """
    ALLIANCES = ["TON Foundation", "Ston.fi", "Fragment", "Nasrium Shadow Network"]

    @staticmethod
    def generate_diplomatic_passport(u_id):
        # ایجاد کد سفارت منحصربه‌فرد (Referral Code)
        import hashlib
        passport_code = hashlib.md5(f"EMBASSY-{u_id}".encode()).hexdigest()[:8].upper()
        return f"NAS-{passport_code}"

    @staticmethod
    def calculate_diplomatic_rank(invite_count):
        if invite_count >= 50: return "Grand Ambassador"
        if invite_count >= 10: return "Diplomat"
        if invite_count >= 1: return "Attache"
        return "Observer"

    @staticmethod
    def get_active_alliances():
        return DiplomaticCore.ALLIANCES
