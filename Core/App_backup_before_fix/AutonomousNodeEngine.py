class AutonomousNodeEngine:
    # وضعیت نودهای شبکه {node_id: {host_id, status, traffic_processed}}
    ACTIVE_NODES = {
        "NODE-PRIMARY": {"host": "SYSTEM", "status": "Stable", "load": 0.12},
        "NODE-SEC-01": {"host": "SYSTEM", "status": "Stable", "load": 0.05}
    }

    @staticmethod
    def register_host(player_data):
        # بررسی سطح شهروندی (فقط Elite و Sovereign)
        tier = player_data.get("id_card", {}).get("tier", "CITIZEN")
        if tier not in ["ELITE", "SOVEREIGN"]:
            return False, "Access Denied: Elite or Sovereign ID required for Node Hosting."
        
        node_id = f"NODE-{player_data['user_id']}"
        AutonomousNodeEngine.ACTIVE_NODES[node_id] = {
            "host": player_data.get("username", "Unknown"),
            "status": "Active",
            "load": 0.0,
            "processed": 0
        }
        player_data["is_node_host"] = True
        return True, f"System Integration Complete: Node {node_id} is now online."

    @staticmethod
    def get_network_health():
        return AutonomousNodeEngine.ACTIVE_NODES
