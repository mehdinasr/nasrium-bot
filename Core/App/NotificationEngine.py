import time

class NotificationEngine:
    @staticmethod
    def add_notification(player_data, n_type, message):
        notifs = player_data.get("notifications", [])
        new_notif = {
            "id": int(time.time() * 1000),
            "type": n_type, # WAR, TRADE, SYSTEM
            "msg": message,
            "time": time.strftime("%H:%M:%S"),
            "read": False
        }
        notifs.append(new_notif)
        # نگهداری ۲۰ اعلان آخر
        player_data["notifications"] = notifs[-20:]
        return player_data

    @staticmethod
    def mark_all_read(player_data):
        notifs = player_data.get("notifications", [])
        for n in notifs:
            n["read"] = True
        player_data["notifications"] = notifs
        return player_data
