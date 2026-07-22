class NasriumSwap:
    """CMD_967: صرافی داخلی برای تبدیل IXP به توکن NSM."""
    SWAP_RATE = 1000000 # هر ۱ میلیون IXP = ۱ توکن NSM
    LIQUIDITY_RESERVE = 5000000000 # ۵ میلیارد IXP در ذخیره

    @staticmethod
    def execute_swap(player_data, ixp_amount):
        if player_data.get("intel_xp", 0) < ixp_amount:
            return False, "Insufficient IXP for conversion."
        
        nsm_to_receive = ixp_amount / NasriumSwap.SWAP_RATE
        player_data["intel_xp"] -= ixp_amount
        player_data["nsm_tokens"] = player_data.get("nsm_tokens", 0) + nsm_to_receive
        return True, f"Conversion Complete: {nsm_to_receive} NSM minted."

class GasLogic:
    """CMD_969: منطق گاز برای کنترل تورم (سوزاندن IXP)."""
    @staticmethod
    def apply_gas_fee(amount, fee_percent=0.01):
        # سوزاندن ۱٪ از هر تراکنش بزرگ برای حفظ ارزش
        fee = amount * fee_percent
        return amount - fee, fee

class OnChainStaking:
    """CMD_968: زیرساخت استیکینگ NSM برای حاکمیت."""
    @staticmethod
    def stake_nsm(player_data, nsm_amount):
        if player_data.get("nsm_tokens", 0) < nsm_amount:
            return False, "Not enough NSM tokens."
        player_data["nsm_tokens"] -= nsm_amount
        player_data["staked_nsm"] = player_data.get("staked_nsm", 0) + nsm_amount
        return True, f"{nsm_amount} NSM staked in the Sovereign Vault."
