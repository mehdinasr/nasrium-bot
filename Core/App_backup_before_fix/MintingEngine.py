import time

class MintingEngine:
    MINT_QUEUE = []

    @staticmethod
    def add_to_mint_queue(player_id, wallet, amount, signature):
        # بررسی تکراری نبودن درخواست
        if any(item['u_id'] == player_id for item in MintingEngine.MINT_QUEUE):
            return False, "Transaction already in global minting queue."

        mint_request = {
            "u_id": player_id,
            "address": wallet,
            "nsm_amount": amount,
            "sig": signature,
            "added_at": time.time(),
            "batch_id": f"BCH-{int(time.time() / 3600)}"
        }
        
        MintingEngine.MINT_QUEUE.append(mint_request)
        return True, "Request successfully added to Imperial Minting Queue."

    @staticmethod
    def get_queue_stats():
        return {
            "total_pending": len(MintingEngine.MINT_QUEUE),
            "total_volume": sum(item['nsm_amount'] for item in MintingEngine.MINT_QUEUE),
            "batches_ready": (len(MintingEngine.MINT_QUEUE) // 50) + 1
        }
