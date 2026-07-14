import time
import random

class SyncEngine:
    # تعریف بلاک‌های داده برای پردازش
    BLOCKS = {
        "low_density": {"name": "Minor Data Node", "duration": 3600, "shards": 1, "intel_xp": 50},
        "high_density": {"name": "Core Neural Block", "duration": 14400, "shards": 5, "intel_xp": 250}
    }

    @staticmethod
    def start_sync(player_data, block_id):
        if not player_data.get("active_agent"):
            return False, "Neural Link required. Connect an AI Agent first."
        
        if player_data.get("is_syncing", False):
            if time.time() < player_data.get("sync_until", 0):
                return False, "Sync Bridge already occupied."

        block = SyncEngine.BLOCKS.get(block_id)
        player_data["is_syncing"] = True
        player_data["sync_until"] = time.time() + block["duration"]
        player_data["active_block"] = block_id
        
        return True, f"Neural Sync initiated: Processing {block['name']}."

    @staticmethod
    def collect_sync_rewards(player_data):
        if not player_data.get("is_syncing") or time.time() < player_data.get("sync_until", 0):
            return False, "Processing not complete.", None

        block = SyncEngine.BLOCKS[player_data["active_block"]]
        
        # ثبت پاداش‌ها
        shards = block["shards"]
        intel_xp = block["intel_xp"]
        
        player_data["nsm_shards"] = player_data.get("nsm_shards", 0) + shards
        player_data["intel_xp"] = player_data.get("intel_xp", 0) + intel_xp
        
        # آزاد کردن پل
        player_data["is_syncing"] = False
        player_data["active_block"] = None
        
        return True, f"Sync Complete. Extracted {shards} Shards and {intel_xp} Intel XP.", {"shards": shards, "xp": intel_xp}
