class ClanEngine:
    @staticmethod
    def create_syndicate(clan_name: str, creator_id: int) -> dict:
        if not clan_name or len(clan_name) > 20:
            return {'success': False, 'message': 'Invalid Syndicate name (Max 20 chars)'}
        return {'success': True, 'clan_name': clan_name, 'creator_id': creator_id, 'message': f'🏗️ Syndicate {clan_name} created!'}

    @staticmethod
    def join_syndicate(clan_id: str, user_id: int) -> dict:
        if not clan_id:
            return {'success': False, 'message': 'Invalid Syndicate ID'}
        return {'success': True, 'clan_id': clan_id, 'user_id': user_id, 'message': '🤝 Joined Syndicate successfully!'}
