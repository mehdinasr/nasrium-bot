class BountyEngine:
    """
    مدیریت مأموریت‌های روزانه نصریوم.
    """
    DAILY_TASKS = [
        {"id": "task_login", "desc": "Enter the Empire today", "reward_ixp": 500, "reward_honor": 5},
        {"id": "task_mine", "desc": "Start a Deep Mining session", "reward_ixp": 1000, "reward_honor": 10},
        {"id": "task_duel", "desc": "Participate in 1 Arena Duel", "reward_ixp": 1500, "reward_honor": 15}
    ]

    @staticmethod
    def get_tasks(player_data):
        completed = player_data.get("completed_bounties", [])
        tasks_with_status = []
        for task in BountyEngine.DAILY_TASKS:
            task_copy = task.copy()
            task_copy["is_done"] = task["id"] in completed
            tasks_with_status.append(task_copy)
        return tasks_with_status

    @staticmethod
    def complete_task(player_data, task_id):
        completed = player_data.get("completed_bounties", [])
        if task_id in completed:
            return False, "Bounty already claimed."
        
        # پیدا کردن مأموریت
        task = next((t for t in BountyEngine.DAILY_TASKS if t["id"] == task_id), None)
        if not task:
            return False, "Unknown mission ID."

        # اعطای پاداش
        player_data["intel_xp"] += task["reward_ixp"]
        player_data["honor_score"] = player_data.get("honor_score", 0) + task["reward_honor"]
        
        # ثبت در لیست انجام شده‌ها
        if "completed_bounties" not in player_data:
            player_data["completed_bounties"] = []
        player_data["completed_bounties"].append(task_id)
        
        return True, f"Bounty Claimed! +{task['reward_ixp']} IXP and +{task['reward_honor']} Honor."
