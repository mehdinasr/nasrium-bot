import time

class CourtEngine:
    # آرشیو پرونده‌های قضایی {case_id: {plaintiff, defendant, reason, status}}
    ACTIVE_CASES = {}

    @staticmethod
    def file_case(plaintiff_fed, defendant_id, reason):
        case_id = f"CASE-{int(time.time())}"
        CourtEngine.ACTIVE_CASES[case_id] = {
            "plaintiff": plaintiff_fed,
            "defendant": defendant_id,
            "reason": reason,
            "timestamp": time.time(),
            "status": "UNDER_REVIEW" # وضعیت اولیه: در حال بررسی
        }
        return True, f"Legal proceedings initiated. Case ID: {case_id}"

    @staticmethod
    def get_case_list():
        return CourtEngine.ACTIVE_CASES
