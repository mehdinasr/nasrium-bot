class DepositEngine:
    @staticmethod
    def link_wallet(player_data, wallet_address):
        # بررسی فرمت اولیه آدرس TON (ساده شده)
        if not wallet_address or len(wallet_address) < 10:
            return False, "Invalid TON Address"
        
        player_data["wallet_address"] = wallet_address
        player_data["wallet_active"] = True
        return True, "Wallet linked successfully to NASRIUM."
