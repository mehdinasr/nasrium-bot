import time
from Core.App.TonClient import TonClient

TON_TO_NSM_HARD_RATE = 100  # 1 TON = 100 nsm_hard (placeholder, tune as needed)
MIN_WITHDRAWAL_NSM_HARD = 50
WITHDRAWAL_FEE_TON = 0.02  # network fee reserve


class WalletEngine:
    EXCHANGE_RATE = 1000000  # 1 TON = 1,000,000 IXP (existing, unrelated to nsm_hard)

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

    @staticmethod
    def check_and_process_deposits(user_id, player_data, processed_collection, deposit_address):
        try:
            txs = TonClient.get_incoming_transactions(deposit_address, limit=30)
        except Exception as e:
            return {"success": False, "message": f"Could not reach TON network: {e}"}

        credited_total = 0
        newly_processed = []

        for tx in txs:
            in_msg = tx.get("in_msg", {})
            comment = (in_msg.get("message") or "").strip()
            value = int(in_msg.get("value", 0) or 0)
            tx_id = tx.get("transaction_id", {})
            tx_hash = tx_id.get("hash")

            if comment != str(user_id) or value <= 0 or not tx_hash:
                continue

            already = processed_collection.find_one({"tx_hash": tx_hash})
            if already:
                continue

            ton_amount = value / 1000000000
            nsm_hard_earned = int(ton_amount * TON_TO_NSM_HARD_RATE)
            credited_total += nsm_hard_earned

            processed_collection.insert_one({
                "tx_hash": tx_hash,
                "user_id": user_id,
                "ton_amount": ton_amount,
                "nsm_hard_credited": nsm_hard_earned,
                "processed_at": time.time()
            })
            newly_processed.append(tx_hash)

        new_balance = player_data.get("nsm_hard", 0) + credited_total
        return {
            "success": True,
            "credited_nsm_hard": credited_total,
            "new_nsm_hard": new_balance,
            "transactions_processed": len(newly_processed)
        }

    @staticmethod
    def attempt_withdrawal(player_data, amount_nsm_hard):
        wallet_address = player_data.get("ton_wallet")
        if not wallet_address:
            return {"success": False, "message": "No TON wallet linked."}

        if amount_nsm_hard < MIN_WITHDRAWAL_NSM_HARD:
            return {"success": False, "message": f"Minimum withdrawal is {MIN_WITHDRAWAL_NSM_HARD} nsm_hard."}

        current_balance = player_data.get("nsm_hard", 0)
        if current_balance < amount_nsm_hard:
            return {"success": False, "message": "Insufficient nsm_hard balance."}

        ton_amount = (amount_nsm_hard / TON_TO_NSM_HARD_RATE) - WITHDRAWAL_FEE_TON
        if ton_amount <= 0:
            return {"success": False, "message": "Amount too small after fees."}

        amount_nano = int(ton_amount * 1000000000)

        try:
            result = TonClient.send_transfer(
                to_address=wallet_address,
                amount_nano=amount_nano,
                comment="Nasrium withdrawal"
            )
        except Exception as e:
            return {"success": False, "message": f"Transaction failed: {e}"}

        if not result.get("ok"):
            return {"success": False, "message": f"Broadcast failed: {result}"}

        new_balance = current_balance - amount_nsm_hard
        return {
            "success": True,
            "new_nsm_hard": new_balance,
            "ton_sent": ton_amount,
            "message": f"Withdrew {ton_amount:.4f} TON successfully."
        }
