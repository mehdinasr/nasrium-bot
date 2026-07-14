import re

class BridgeEngine:
    # نرخ تبدیل: هر ۱۰۰ شارد عصبی = ۱ توکن NSM Hard
    CONVERSION_RATE = 100 

    @staticmethod
    def validate_ton_address(address):
        # بررسی فرمت استاندارد آدرس‌های TON (۴۸ کاراکتر، شروع با E یا U)
        pattern = r"^(EQ|UQ)[a-zA-Z0-9_-]{46}$"
        if re.match(pattern, address):
            return True
        return False

    @staticmethod
    def get_token_estimate(shards):
        # تخمین توکن نهایی بر اساس شاردهای موجود
        return round(shards / BridgeEngine.CONVERSION_RATE, 2)

    @staticmethod
    def link_wallet(player_data, address):
        if not BridgeEngine.validate_ton_address(address):
            return False, "Invalid TON Address format."
        
        player_data["ton_wallet"] = address
        return True, "TON Wallet successfully linked to your Imperial Identity."
