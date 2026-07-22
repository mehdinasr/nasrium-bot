import hashlib
import time

class ClaimEngine:
    @staticmethod
    def generate_claim_ticket(player_data):
        # ۱. بررسی اینکه آیا وضعیت در سجل فریز شده است؟
        if not player_data.get("is_registered_in_registry", False):
            return False, "You must seal your state in the Sovereign Registry first."
        
        # ۲. بازیابی دیتای سجل
        reg_record = player_data.get("final_registry_record", {})
        total_nsm = reg_record.get("final_allocation", 0)
        unlock_amount = int(total_nsm * 0.25) # ۲۵٪ آزادسازی آنی

        # ۳. تولید هش آزادسازی (Release Hash)
        raw_ticket = f"CLAIM:{player_data['user_id']}:{unlock_amount}:{time.time()}"
        claim_hash = hashlib.sha256(raw_ticket.encode()).hexdigest().upper()

        ticket = {
            "ticket_id": f"TKT-{claim_hash[:10]}",
            "claimable_now": unlock_amount,
            "total_allocation": total_nsm,
            "status": "READY_TO_CLAIM",
            "release_signature": claim_hash
        }
        
        player_data["claim_ticket"] = ticket
        return True, ticket
