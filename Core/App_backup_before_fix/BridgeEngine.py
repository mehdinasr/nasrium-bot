class BridgeEngine:
    # شبکه‌های مورد حمایت و کارمزد
    NETWORKS = {
        "ETH": {"name": "Ethereum", "fee_pct": 0.05, "min_amt": 100},
        "SOL": {"name": "Solana", "fee_pct": 0.03, "min_amt": 50},
        "BSC": {"name": "Binance Smart Chain", "fee_pct": 0.02, "min_amt": 20}
    }

    @staticmethod
    def request_transfer(player_data, target_net, amount, target_address):
        net = BridgeEngine.NETWORKS.get(target_net)
        if not net: return False, "Target world not reachable by current bridge technology."

        if player_data.get("nsm_hard", 0) < amount:
            return False, "Insufficient NSM Hard for cross-chain jump."

        if amount < net["min_amt"]:
            return False, f"Minimum bridge amount for {target_net} is {net['min_amt']} NSM."

        # محاسبه کارمزد و کسر دارایی
        fee = int(amount * net["fee_pct"])
        total_deduction = amount # کل مبلغ از حساب ناصریوم کسر می‌شود
        
        player_data["nsm_hard"] -= total_deduction
        
        # ثبت تراکنش در صف انتظار پل (Bridge Queue)
        transfer_entry = {
            "network": target_net,
            "address": target_address,
            "amount": amount - fee,
            "fee": fee,
            "status": "PROCESSING"
        }
        
        queue = player_data.get("bridge_queue", [])
        queue.append(transfer_entry)
        player_data["bridge_queue"] = queue
        
        return True, f"Warp Drive Engaged: {amount - fee} NSM is being bridged to {net['name']}."
