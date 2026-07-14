import hashlib
import time

class ContractEngine:
    # شبیه‌سازی آدرس قرارداد هوشمند NSM روی شبکه TON
    NSM_CONTRACT_ADDRESS = "EQC-NSM-IMPERIAL-MASTER-BRIDGE-V1"

    @staticmethod
    def format_for_blockchain(player_id, wallet, amount):
        # تولید یک هش امن برای تراکنش (Payload)
        raw_data = f"{player_id}:{wallet}:{amount}:{time.time()}"
        tx_hash = hashlib.sha256(raw_data.encode()).hexdigest().upper()
        
        return {
            "destination": wallet,
            "amount_nanoton": int(amount * 10**9), # تبدیل به واحد نانو
            "payload": tx_hash,
            "contract": ContractEngine.NSM_CONTRACT_ADDRESS
        }

    @staticmethod
    def sign_transaction(tx_data):
        # شبیه‌سازی امضای تراکنش با کلید خصوصی سرور
        signature = hashlib.md5(tx_data["payload"].encode()).hexdigest()
        tx_data["signature"] = signature
        return tx_data
