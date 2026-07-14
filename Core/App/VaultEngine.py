class VaultEngine:
    VAULT_REGISTRY = {} # {player_id: {stored_gold, max_capacity, protection_level}}

    @staticmethod
    def initialize_vault(player_id):
        VaultEngine.VAULT_REGISTRY[player_id] = {
            "stored_gold": 0,
            "max_capacity": 500000,
            "protection_level": 1 # سطح رمزنگاری
        }
        return True

    @staticmethod
    def deposit_asset(player_id, amount):
        if player_id not in VaultEngine.VAULT_REGISTRY:
            VaultEngine.initialize_vault(player_id)
            
        vault = VaultEngine.VAULT_REGISTRY[player_id]
        
        if vault["stored_gold"] + amount > vault["max_capacity"]:
            return False, "Vault Maximum Capacity Reached! Upgrade infrastructure."
            
        vault["stored_gold"] += amount
        loot_protection = min(98, 50 + (vault["protection_level"] * 8))
        
        return True, {
            "stored": vault["stored_gold"],
            "capacity": vault["max_capacity"],
            "loot_protection_percent": loot_protection
        }

    @staticmethod
    def upgrade_vault_shields(player_id):
        if player_id in VaultEngine.VAULT_REGISTRY:
            VaultEngine.VAULT_REGISTRY[player_id]["protection_level"] += 1
            VaultEngine.VAULT_REGISTRY[player_id]["max_capacity"] = int(VaultEngine.VAULT_REGISTRY[player_id]["max_capacity"] * 1.5)
            return True, VaultEngine.VAULT_REGISTRY[player_id]
        return False, "Vault not initialized."
