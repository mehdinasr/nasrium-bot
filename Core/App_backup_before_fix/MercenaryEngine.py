import time

class MercenaryEngine:
    # تعریف انواع قراردادهای مزدور
    CONTRACTS = {
        "ghost": {"name": "The Ghost", "cost_nsm": 500, "type": "spy_buff", "desc": "Guaranteed Spy Success (1 use)"},
        "enforcer": {"name": "The Enforcer", "cost_nsm": 800, "type": "atk_buff", "desc": "+500 ATK Power (1 use)"},
        "techie": {"name": "The Techie", "cost_nsm": 1200, "type": "instabuild", "desc": "Instant Construction Finish"}
    }

    @staticmethod
    def hire_mercenary(player_data, contract_id):
        contract = MercenaryEngine.CONTRACTS.get(contract_id)
        if not contract: return False, "Invalid Contract ID."

        if player_data.get("nsm_soft", 0) < contract["cost_nsm"]:
            return False, "Insufficient NSM Soft for this contract."

        # کسر هزینه
        player_data["nsm_soft"] -= contract["cost_nsm"]

        # اعمال اثر آنی برای تکنیسین
        if contract["type"] == "instabuild":
            if player_data.get("is_building", False):
                player_data["construction_until"] = time.time()
                return True, "Techie completed the construction instantly!"
            else:
                return False, "No active construction found."

        # ذخیره قرارداد برای استفاده در نبردهای بعدی
        active_contracts = player_data.get("active_contracts", [])
        active_contracts.append(contract_id)
        player_data["active_contracts"] = active_contracts

        return True, f"Contract signed: {contract['name']} is ready for deployment."
