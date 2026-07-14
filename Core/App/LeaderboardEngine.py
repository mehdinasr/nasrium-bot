class LeaderboardEngine:
    """
    استخراج و مرتب‌سازی برترین شهروندان امپراتوری.
    """
    @staticmethod
    def get_top_commanders(all_players, limit=10):
        # مرتب‌سازی بر اساس IXP (و در صورت تساوی، بر اساس Honor Score)
        sorted_players = sorted(
            all_players, 
            key=lambda x: (x.get('intel_xp', 0), x.get('honor_score', 0)), 
            reverse=True
        )
        
        top_list = []
        for idx, p in enumerate(sorted_players[:limit]):
            top_list.append({
                "rank": idx + 1,
                "user_id": p.get('user_id'),
                "ixp": p.get('intel_xp', 0),
                "title": p.get('rank', 'Citizen')
            })
        return top_list
