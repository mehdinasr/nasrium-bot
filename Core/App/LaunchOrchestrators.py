import time

class LaunchOrchestrator:
    """مدیریت زمان بندی و توزیع جوایز روز اول."""
    LAUNCH_TIME = 1716381000 # زمان فرضی برای انفجار بزرگ
    @staticmethod
    def get_countdown():
        remaining = LaunchOrchestrator.LAUNCH_TIME - time.time()
        return max(0, int(remaining))

class PioneerBadgeSystem:
    """اعطای مدال های غیرقابل انتقال به اولین شهروندان."""
    @staticmethod
    def award_pioneer(u_id):
        return f"PIONEER_STATUS_CONFIRMED_FOR_{u_id}"
