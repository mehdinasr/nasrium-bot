import time

class BankEngine:
    # تعریف طرح‌های سپرده‌گذاری {id: {days, yield_pct}}
    PLANS = {
        "daily": {"name": "24h Vault", "days": 1, "yield": 0.05},
        "weekly": {"name": "Standard Week", "days": 7, "yield": 0.15},
        "monthly": {"name": "Imperial 30D", "days": 30, "yield": 0.40}
    }

    @staticmethod
    def deposit(player_data, plan_id, amount):
        plan = BankEngine.PLANS.get(plan_id)
        if not plan: return False, "Unknown financial plan."

        if player_data.get("nsm_soft", 0) < amount:
            return False, "Insufficient NSM Soft for this deposit."

        # ثبت سپرده در دیتای بازیکن
        player_data["nsm_soft"] -= amount
        deposit_entry = {
            "plan_id": plan_id,
            "amount": amount,
            "start_time": time.time(),
            "end_time": time.time() + (plan["days"] * 86400),
            "status": "ACTIVE"
        }
        
        deposits = player_data.get("active_deposits", [])
        deposits.append(deposit_entry)
        player_data["active_deposits"] = deposits
        
        return True, f"Capital Locked in {plan['name']}. Your yield is maturing."

    @staticmethod
    def claim_yield(player_data, deposit_index):
        deposits = player_data.get("active_deposits", [])
        if deposit_index >= len(deposits): return False, "Deposit record not found."
        
        dep = deposits[deposit_index]
        plan = BankEngine.PLANS[dep["plan_id"]]
        
        if time.time() < dep["end_time"]:
            # برداشت زودتر از موعد = جریمه ۱۰ درصدی
            penalty = int(dep["amount"] * 0.10)
            payout = dep["amount"] - penalty
            msg = f"Early Withdrawal Penalty: {penalty} NSM. Received {payout}."
        else:
            # برداشت کامل با سود
            profit = int(dep["amount"] * plan["yield"])
            payout = dep["amount"] + profit
            msg = f"Contract Fulfilled: Received {payout} NSM (Profit: {profit})."
        
        player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + payout
        deposits.pop(deposit_index)
        player_data["active_deposits"] = deposits
        
        return True, msg
