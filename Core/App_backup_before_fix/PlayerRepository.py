import os
from pymongo import MongoClient

class PlayerRepository:
    MONGO_URL = os.environ.get('MONGO_URL', 'mongodb://localhost:27017')
    DB_NAME = "nasrium_db"

    @staticmethod
    def get_db():
        client = MongoClient(PlayerRepository.MONGO_URL, serverSelectionTimeoutMS=5000)
        return client[PlayerRepository.DB_NAME]

    @staticmethod
    def get_player(user_id):
        try:
            db = PlayerRepository.get_db()
            player = db.players.find_one({"user_id": user_id})
            if player:
                player['_id'] = str(player['_id'])
                return player
            return None
        except Exception: return None

    @staticmethod
    def create_or_update_player(player_data):
        try:
            db = PlayerRepository.get_db()
            user_id = player_data.get("user_id")
            db.players.update_one(
                {"user_id": user_id},
                {"$set": player_data},
                upsert=True
            )
            return True
        except Exception as e:
            print(f"Update Error: {e}")
            return False
    @staticmethod
    def add_log(user_id, message):
        try:
            db = PlayerRepository.get_db()
            log_entry = {
                "user_id": user_id,
                "message": message,
                "timestamp": time.time()
            }
            db.battle_logs.insert_one(log_entry)
            # نگه داشتن فقط 10 لاگ آخر برای بهینگی
            db.battle_logs.delete_many({"user_id": user_id, "_id": {"$in": [x["_id"] for x in list(db.battle_logs.find({"user_id": user_id}).sort("timestamp", 1).limit(max(0, db.battle_logs.count_documents({"user_id": user_id}) - 10)))]}})
        except: pass

    @staticmethod
    def broadcast_to_all(message):
        try:
            db = PlayerRepository.get_db()
            players = db.players.find({}, {"user_id": 1})
            log_entries = []
            ts = time.time()
            for p in players:
                log_entries.append({
                    "user_id": p["user_id"],
                    "message": f"📢 [OFFICIAL]: {message}",
                    "timestamp": ts
                })
            if log_entries:
                db.battle_logs.insert_many(log_entries)
            return True
        except Exception as e:
            print(f"Broadcast Error: {e}")
            return False
