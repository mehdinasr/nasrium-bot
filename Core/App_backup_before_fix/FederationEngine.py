class FederationEngine:
    # دیتابیس موقت فدراسیون‌ها {fed_id: {name, lead_syn, members: []}}
    ACTIVE_FEDERATIONS = {}

    @staticmethod
    def create_federation(player_data, fed_name):
        syn_data = player_data.get("syndicate_data", {})
        syn_name = player_data.get("syndicate")
        
        if not syn_name or syn_name == "None":
            return False, "You must lead a Syndicate to form a Federation."
        
        # هزینه تشکیل فدراسیون: 100,000 توکن NSM Soft از خزانه سندیکا
        if syn_data.get("war_chest_nsm", 0) < 100000:
            return False, "Insufficient NSM Soft in Syndicate War Chest (100k required)."

        fed_id = f"FED-{fed_name.upper()}"
        FederationEngine.ACTIVE_FEDERATIONS[fed_id] = {
            "name": fed_name,
            "leader_syndicate": syn_name,
            "members": [syn_name],
            "total_influence": syn_data.get("xp", 0)
        }
        
        syn_data["war_chest_nsm"] -= 100000
        syn_data["federation_id"] = fed_id
        return True, f"Federation {fed_name} established. The era of Power Blocks has begun."

    @staticmethod
    def join_federation(target_syn_data, fed_id):
        if fed_id not in FederationEngine.ACTIVE_FEDERATIONS:
            return False, "Federation not found."
        
        fed = FederationEngine.ACTIVE_FEDERATIONS[fed_id]
        syn_name = target_syn_data.get("name")
        
        if syn_name in fed["members"]:
            return False, "Syndicate already part of this Federation."
            
        fed["members"].append(syn_name)
        target_syn_data["federation_id"] = fed_id
        return True, f"Syndicate {syn_name} has joined Federation {fed['name']}."
