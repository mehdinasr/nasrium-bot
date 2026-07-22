import time

class LaunchEngine:
    # وضعیت نهایی تمام ماژول‌های حیاتی
    SYSTEM_CHECKLIST = {
        "Economy": "ACTIVE",
        "Military": "ACTIVE",
        "AI_Agents": "ACTIVE",
        "Web3_Bridge": "ACTIVE",
        "Governance": "ACTIVE"
    }

    @staticmethod
    def get_launch_status():
        return {
            "phase": "GENESIS_V1",
            "version": "1.0.0",
            "uptime": time.time(),
            "checklist": LaunchEngine.SYSTEM_CHECKLIST,
            "is_stable": True
        }

    @staticmethod
    def assign_founder_tag(player_data):
        # اختصاص تگ بنیان‌گذار به اولین شهروندان
        if "medals" not in player_data:
            player_data["medals"] = []
        
        if "title_founder" not in player_data["medals"]:
            player_data["medals"].append("title_founder")
            player_data["active_title"] = "Genesis Founder"
            return True, "Imperial Genesis Tag Assigned."
        return False, "Already a Founder."
