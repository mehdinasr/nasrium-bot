import time

class TournamentEngine:
    """
    مدیریت مسابقات دوره‌ای و نبردهای گروهی لژیون‌ها.
    """
    ACTIVE_TOURNAMENT = {
        "id": "GENESIS_WAR_01",
        "name": "The Great Awakening Tournament",
        "prize_pool": 5000000, # ۵ میلیون IXP
        "end_time": time.time() + 604800, # ۷ روز مدت تورنمنت
        "participants": []
    }

    @staticmethod
    def get_info():
        return TournamentEngine.ACTIVE_TOURNAMENT

    @staticmethod
    def register_legion(legion_name, leader_id):
        # بررسی صلاحیت لژیون برای شرکت در جنگ
        if legion_name not in TournamentEngine.ACTIVE_TOURNAMENT["participants"]:
            TournamentEngine.ACTIVE_TOURNAMENT["participants"].append(legion_name)
            return True, f"Legion {legion_name} has entered the War Room."
        return False, "Already registered."
