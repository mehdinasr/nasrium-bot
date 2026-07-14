import hashlib
import time

class LedgerEngine:
    # لیست بلاک‌های تایید شده در حافظه (در نسخه نهایی در DB ذخیره می‌شود)
    BLOCK_CHAIN = []

    @staticmethod
    def generate_hash(data):
        return hashlib.sha256(str(data).encode()).hexdigest()[:16].upper()

    @staticmethod
    def create_block(transactions):
        prev_hash = LedgerEngine.BLOCK_CHAIN[-1]["hash"] if LedgerEngine.BLOCK_CHAIN else "0000000000000000"
        block_id = len(LedgerEngine.BLOCK_CHAIN) + 1
        
        block = {
            "id": block_id,
            "timestamp": time.time(),
            "prev_hash": prev_hash,
            "tx_count": len(transactions),
            "transactions": transactions,
            "hash": ""
        }
        block["hash"] = LedgerEngine.generate_hash(block)
        
        LedgerEngine.BLOCK_CHAIN.append(block)
        if len(LedgerEngine.BLOCK_CHAIN) > 20: # نگهداری ۲۰ بلاک آخر در حافظه زنده
            LedgerEngine.BLOCK_CHAIN.pop(0)
        
        return block

    @staticmethod
    def get_latest_blocks():
        return LedgerEngine.BLOCK_CHAIN[::-1]
