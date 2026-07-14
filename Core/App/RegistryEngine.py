import hashlib
import time

class RegistryEngine:
    @staticmethod
    def seal_state(player_data, convergence_statement):
        # بررسی اینکه آیا قبلاً ثبت شده است؟
        if player_data.get("is_registered_in_registry", False):
            return False, "State is already sealed in the Sovereign Registry."

        # ایجاد هش سجل (اثر انگشت نهایی وضعیت)
        raw_string = f"{player_data['user_id']}:{convergence_statement['final_nsm_hard']}:{time.time()}"
        registry_hash = hashlib.sha256(raw_string.encode()).hexdigest().upper()
        
        # انجماد داده‌ها
        registration_record = {
            "registry_id": f"REG-{registry_hash[:12]}",
            "final_allocation": convergence_statement["final_nsm_hard"],
            "timestamp": time.time(),
            "status": "SEALED",
            "fingerprint": registry_hash
        }
        
        player_data["is_registered_in_registry"] = True
        player_data["final_registry_record"] = registration_record
        
        return True, registration_record
