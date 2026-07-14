class ShardEngine:
    # تعریف خوشه‌های فعال
    CLUSTERS = {
        "SHARD-ALPHA": {"status": "Operational", "load": 15},
        "SHARD-BETA":  {"status": "Operational", "load": 8},
        "SHARD-GAMMA": {"status": "Standby", "load": 0}
    }

    @staticmethod
    def get_assigned_shard(user_id):
        # توزیع قطعی بر اساس باقی‌مانده تقسیم (Deterministic Sharding)
        try:
            u_num = int(user_id)
        except:
            u_num = sum(ord(c) for c in str(user_id))
            
        shard_keys = list(ShardEngine.CLUSTERS.keys())
        assigned = shard_keys[u_num % len(shard_keys)]
        return assigned

    @staticmethod
    def get_cluster_health():
        return ShardEngine.CLUSTERS
