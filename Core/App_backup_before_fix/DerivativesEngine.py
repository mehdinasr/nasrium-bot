class DerivativesEngine:
    # قراردادهای فعال پیش‌بینی {contract_id: {event, odds_a, odds_b, total_pool}}
    MARKET_CONTRACTS = {
        "WAR_01": {"title": "Syndicate Alpha Victory", "odds": 1.85, "total_bets": 250000},
        "STK_01": {"title": "NOVA Stock reaches 300", "odds": 4.50, "total_bets": 120000}
    }

    @staticmethod
    def place_prediction(player_data, contract_id, amount):
        contract = DerivativesEngine.MARKET_CONTRACTS.get(contract_id)
        if not contract: return False, "Target contract is not listed in the Imperial Exchange."

        if player_data.get("nsm_soft", 0) < amount:
            return False, "Insufficient NSM Soft for this high-risk prediction."

        # کسر مبلغ و ثبت در لیست پیش‌بینی‌های بازیکن
        player_data["nsm_soft"] -= amount
        contract["total_bets"] += amount
        
        prediction_entry = {
            "contract_id": contract_id,
            "amount": amount,
            "potential_payout": int(amount * contract["odds"]),
            "status": "PENDING"
        }
        
        predictions = player_data.get("predictions", [])
        predictions.append(prediction_entry)
        player_data["predictions"] = predictions
        
        return True, f"Risk Registered. Potential Return: {prediction_entry['potential_payout']} NSM."

    @staticmethod
    def get_market():
        return DerivativesEngine.MARKET_CONTRACTS
