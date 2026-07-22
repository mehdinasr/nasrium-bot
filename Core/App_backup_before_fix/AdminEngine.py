class AdminEngine:
    # این کلید باید محرمانه بماند. در نسخه نهایی در Environment Variable قرار میگیرد
    COMMANDER_SECRET_KEY = "NAXUS_SUPREME_CMD_MEHDI_2024"

    @staticmethod
    def verify_commander(key: str) -> bool:
        return key == AdminEngine.COMMANDER_SECRET_KEY

    @staticmethod
    def grant_resources(uid: int, resource_type: str, amount: int) -> dict:
        if resource_type not in ['gold', 'gems', 'nsm_soft', 'nsm_hard', 'troops']:
            return {'success': False, 'message': 'Invalid resource type'}
        return {'success': True, 'update': {'$inc': {resource_type: amount}}}

    @staticmethod
    def ban_target(uid: int) -> dict:
        return {'success': True, 'update': {'$set': {'is_banned': True, 'ban_reason': 'Commander Decree'}}}

    @staticmethod
    def unban_target(uid: int) -> dict:
        return {'success': True, 'update': {'$set': {'is_banned': False, 'ban_reason': ''}}}
