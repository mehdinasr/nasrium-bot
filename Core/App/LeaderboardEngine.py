class LeaderboardEngine:
    @staticmethod
    def get_rankings(all_players, category):
        # سورت کردن بازیکنان بر اساس دسته انتخاب شده
        if category == "power":
            sorted_list = sorted(all_players, key=lambda x: x.get("troops", 0), reverse=True)
        elif category == "wealth":
            sorted_list = sorted(all_players, key=lambda x: x.get("nsm_soft", 0), reverse=True)
        elif category == "influence":
            sorted_list = sorted(all_players, key=lambda x: len(x.get("recruits", [])), reverse=True)
        else:
            return []

        # بازگرداندن ۱۰ نفر اول با فرمت ساده
        rankings = []
        for i, p in enumerate(sorted_list[:10]):
            rankings.append({
                "rank": i + 1,
                "username": p.get("username", "Unknown Citizen"),
                "value": p.get("troops", 0) if category == "power" else (p.get("nsm_soft", 0) if category == "wealth" else len(p.get("recruits", [])))
            })
        return rankings
