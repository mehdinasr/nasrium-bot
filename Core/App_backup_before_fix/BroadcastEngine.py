class BroadcastEngine:
    """
    مدیریت پیام‌های فوری و سراسری فرمانده کل.
    """
    ACTIVE_MESSAGE = {
        "id": 0,
        "type": "NORMAL", # NORMAL, EMERGENCY, EVENT
        "content": "",
        "active": False
    }

    @staticmethod
    def set_broadcast(content, b_type="NORMAL"):
        BroadcastEngine.ACTIVE_MESSAGE = {
            "id": BroadcastEngine.ACTIVE_MESSAGE["id"] + 1,
            "type": b_type,
            "content": content,
            "active": True
        }
        return True

    @staticmethod
    def clear_broadcast():
        BroadcastEngine.ACTIVE_MESSAGE["active"] = False

    @staticmethod
    def get_current():
        return BroadcastEngine.ACTIVE_MESSAGE
