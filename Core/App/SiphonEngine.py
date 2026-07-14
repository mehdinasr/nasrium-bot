import json
import time

class SiphonEngine:
    @staticmethod
    def generate_genesis_snapshot(all_players):
        snapshot_list = []
        total_nsm_to_mint = 0
        
        for p in all_players:
            # فقط بازیکنانی که مرحله SEAL را انجام داده اند
            if p.get("is_registered_in_registry", False) and "final_registry_record" in p:
                record = p["final_registry_record"]
                claim_tkt = p.get("claim_ticket", {})
                
                entry = {
                    "user_id": p["user_id"],
                    "ton_wallet": p.get("ton_wallet"),
                    "total_allocation": record["final_allocation"],
                    "unlock_now": claim_tkt.get("claimable_now", 0),
                    "signature": claim_tkt.get("release_signature"),
                    "timestamp": record["timestamp"]
                }
                
                snapshot_list.append(entry)
                total_nsm_to_mint += entry["total_allocation"]

        metadata = {
            "snapshot_id": f"GENESIS-{int(time.time())}",
            "total_recipients": len(snapshot_list),
            "total_supply_needed": total_nsm_to_mint,
            "export_time": time.time(),
            "data": snapshot_list
        }
        
        return metadata
