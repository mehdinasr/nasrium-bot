import time

class BlockchainSyncEngine:
    @staticmethod
    def create_anchor(db, user_id, state_signature):
        # شبیه‌سازی ثبت وضعیت در یک بلوک بلاکچینی
        last_block = db.world_anchors.count_documents({})
        new_block_height = 1000 + last_block + 1
        
        anchor_entry = {
            "user_id": user_id,
            "block_height": new_block_height,
            "state_hash": state_signature,
            "timestamp": time.time(),
            "tx_status": "ANCHORED"
        }
        db.world_anchors.insert_one(anchor_entry)
        
        # بروزرسانی وضعیت بازیکن
        db.players.update_one(
            {"user_id": user_id},
            {"$set": {"last_anchor_block": new_block_height, "last_sync_ts": anchor_entry["timestamp"]}}
        )
        return anchor_entry

    @staticmethod
    def get_sync_status(db, user_id):
        player = db.players.find_one({"user_id": user_id})
        if not player: return None
        
        return {
            "last_block": player.get("last_anchor_block", 0),
            "last_sync": player.get("last_sync_ts", 0),
            "status": "In-Sync" if player.get("last_anchor_block") else "Pending First Anchor"
        }
