class WalletEngine:
    """
    مدیریت اتصال آدرس‌های ولت TON به اکانت‌های نصریوم.
    """
    EXCHANGE_RATE = 1000000 # هر ۱ عدد TON معادل ۱ میلیون IXP (فرضی)

    @staticmethod
    def link_wallet(player_data, wallet_address):
        if not wallet_address or len(wallet_address) < 40:
            return False, "Invalid TON address format."
        
        player_data["ton_wallet"] = wallet_address
        player_data["is_verified_holder"] = True
        return True, f"Wallet {wallet_address[:6]}... linked successfully."

    @staticmethod
    def calculate_ton_to_ixp(ton_amount):
        return int(ton_amount * WalletEngine.EXCHANGE_RATE)
