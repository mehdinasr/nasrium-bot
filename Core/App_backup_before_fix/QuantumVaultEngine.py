class QuantumVaultEngine:
    # سطوح رمزنگاری و هزینه‌ها
    ENCRYPTION_LEVELS = {
        1: {"protection_pct": 0.10, "upgrade_cost": 50000},
        2: {"protection_pct": 0.20, "upgrade_cost": 150000},
        3: {"protection_pct": 0.30, "upgrade_cost": 300000},
        4: {"protection_pct": 0.40, "upgrade_cost": 600000}
    }

    @staticmethod
    def get_protected_amount(player_data):
        lvl = player_data.get("vault_encryption_lvl", 1)
        pct = QuantumVaultEngine.ENCRYPTION_LEVELS.get(lvl, {"protection_pct": 0.10})["protection_pct"]
        total_gold = player_data.get("gold", 0)
        return int(total_gold * pct)

    @staticmethod
    def upgrade_vault(player_data):
        current_lvl = player_data.get("vault_encryption_lvl", 1)
        if current_lvl >= 4: return False, "Quantum Vault at maximum encryption depth."
        
        next_lvl = current_lvl + 1
        cost = QuantumVaultEngine.ENCRYPTION_LEVELS[next_lvl]["upgrade_cost"]

        if player_data.get("gold", 0) < cost:
            return False, f"Insufficient gold. Need {cost} for quantum upgrade."

        player_data["gold"] -= cost
        player_data["vault_encryption_lvl"] = next_lvl
        return True, f"Encryption Depth increased to Layer {next_lvl}. Protection expanded."
