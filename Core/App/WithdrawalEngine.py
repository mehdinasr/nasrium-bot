import time

class WithdrawalEngine:
    MIN_SHARDS = 500
    PROCESS_FEE_GOLD = 5000

    @staticmethod
    def request_withdrawal(player_data, amount_shards):
        # ۱. بررسی موجودی
        current_shards = player_data.get("nsm_shards", 0)
        if amount_shards < WithdrawalEngine.MIN_SHARDS:
            return False, f"Minimum withdrawal is {WithdrawalEngine.MIN_SHARDS} shards."
        
        if current_shards < amount_shards:
            return False, "Insufficient Shards."

        # ۲. بررسی هزینه پردازش (طلا)
        if player_data.get("gold", 0) < WithdrawalEngine.PROCESS_FEE_GOLD:
            return False, f"Need {WithdrawalEngine.PROCESS_FEE_GOLD} Gold for processing fee."

        # ۳. بررسی وضعیت امنیت (Integrity)
        if player_data.get("integrity_score", 100) < 60:
            return False, "Security Integrity too low. Run a System Repair first."

        # کسر دارایی‌ها و ثبت تراکنش
        player_data["nsm_shards"] -= amount_shards
        player_data["gold"] -= WithdrawalEngine.PROCESS_FEE_GOLD
        
        withdrawal_req = {
            "amount": amount_shards,
            "wallet": player_data.get("ton_wallet", "Unknown"),
            "status": "PENDING",
            "timestamp": time.time(),
            "tx_id": f"TXN-{int(time.time())}"
        }
        
        history = player_data.get("withdraw_history", [])
        history.append(withdrawal_req)
        player_data["withdraw_history"] = history
        
        return True, f"Withdrawal request {withdrawal_req['tx_id']} submitted successfully."
