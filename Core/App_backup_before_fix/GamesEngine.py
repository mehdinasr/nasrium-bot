class GamesEngine:
    # پیکربندی بازی‌ها {game_id: {name, reward_per_point, daily_limit}}
    GAMES_CATALOG = {
        "grid_reflex": {"name": "Grid Reflex", "reward_factor": 10, "limit": 3}
    }

    @staticmethod
    def process_score(player_data, game_id, score):
        game = GamesEngine.GAMES_CATALOG.get(game_id)
        if not game: return False, "Unknown sector of the Games Hub."

        # بررسی سهمیه روزانه (ساده‌سازی شده)
        play_count = player_data.get(f"daily_play_{game_id}", 0)
        if play_count >= game["limit"]:
            return False, f"Daily limit reached for {game['name']}. Rest your neural links."

        # محاسبه پاداش
        reward = score * game["reward_factor"]
        player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + reward
        player_data[f"daily_play_{game_id}"] = play_count + 1
        
        return True, f"Match Complete! Score: {score}. Earned {reward} NSM Soft."
