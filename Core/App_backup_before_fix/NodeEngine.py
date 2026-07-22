class NodeEngine:
    # تعریف سطوح زیرساخت
    NODE_CONFIG = {
        "edge": {"name": "Edge Node", "gold_cost": 20000, "scrap_cost": 100, "bonus": "Energy Regen +5%"},
        "core": {"name": "Core Cluster", "gold_cost": 50000, "scrap_cost": 250, "bonus": "Cooldowns -10%"},
        "quantum": {"name": "Quantum Array", "gold_cost": 150000, "scrap_cost": 600, "bonus": "AI Success +15%"}
    }

    @staticmethod
    def get_node_status(player_data):
        return player_data.get("infrastructure", {n: 0 for n in NodeEngine.NODE_CONFIG})

    @staticmethod
    def upgrade_node(player_data, node_id):
        node = NodeEngine.NODE_CONFIG.get(node_id)
        if not node: return False, "Invalid Node ID."
        
        infra = NodeEngine.get_node_status(player_data)
        current_lvl = infra.get(node_id, 0)
        
        # هزینه تصاعدی
        gold_req = node["gold_cost"] * (current_lvl + 1)
        scrap_req = node["scrap_cost"] * (current_lvl + 1)

        if player_data.get("gold", 0) < gold_req or player_data.get("scraps", 0) < scrap_req:
            return False, "Insufficient Gold or Scraps for Infrastructure upgrade."

        player_data["gold"] -= gold_req
        player_data["scraps"] -= scrap_req
        infra[node_id] = current_lvl + 1
        player_data["infrastructure"] = infra
        
        return True, f"Infrastructure evolved: {node['name']} reached Level {current_lvl + 1}."
