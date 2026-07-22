class PropagandaEngine:
    # تعریف تسک‌های اجتماعی
    SOCIAL_TASKS = {
        "tg_join": {"name": "Join Nasrium Intel", "desc": "Join our official TG channel.", "reward_gold": 5000, "reward_nsm": 0, "url": "https://t.me/Nasrium"},
        "x_follow": {"name": "Follow Command on X", "desc": "Follow our X account for updates.", "reward_gold": 0, "reward_nsm": 200, "url": "https://x.com/Nasrium"},
        "yt_sub": {"name": "Neural Broadcast", "desc": "Subscribe to our YouTube channel.", "reward_gold": 10000, "reward_nsm": 500, "url": "https://youtube.com/Nasrium"}
    }

    @staticmethod
    def get_task_status(player_data):
        completed = player_data.get("completed_social_tasks", [])
        tasks = []
        for tid, info in PropagandaEngine.SOCIAL_TASKS.items():
            tasks.append({
                "id": tid,
                "name": info["name"],
                "desc": info["desc"],
                "url": info["url"],
                "gold": info["reward_gold"],
                "nsm": info["reward_nsm"],
                "is_completed": tid in completed
            })
        return tasks

    @staticmethod
    def complete_task(player_data, task_id):
        if task_id not in PropagandaEngine.SOCIAL_TASKS:
            return False, "Invalid Task ID."
        
        completed = player_data.get("completed_social_tasks", [])
        if task_id in completed:
            return False, "Task already rewarded."

        task = PropagandaEngine.SOCIAL_TASKS[task_id]
        
        # واریز پاداش‌ها
        player_data["gold"] += task["reward_gold"]
        player_data["nsm_soft"] += task["reward_nsm"]
        
        completed.append(task_id)
        player_data["completed_social_tasks"] = completed
        
        return True, f"Propaganda Verified! Gained {task['reward_gold']} Gold and {task['reward_nsm']} NSM."
