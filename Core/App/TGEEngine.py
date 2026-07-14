import time

class TGEEngine:
    # تاریخ هدف برای اسنپ‌شات نهایی (مثلاً ۷ روز آینده)
    TGE_TIMESTAMP = int(time.time()) + 604800 

    @staticmethod
    def get_countdown():
        remaining = TGE_TIMESTAMP - time.time()
        return max(0, int(remaining))

    @staticmethod
    def lock_account_for_tge(player_data):
        if not player_data.get("mainnet_certified", False):
            return False, "You must be Certified to lock your allocation."
        
        if player_data.get("tge_locked", False):
            return False, "Account already sealed for Snapshot."

        player_data["tge_locked"] = True
        player_data["lock_timestamp"] = time.time()
        return True, "Imperial Seal applied. Your assets are secured for Mainnet transfer."
