import os
from pymongo import MongoClient
import time

MONGO_URL = os.environ.get("MONGO_URL")
client = MongoClient(MONGO_URL)
db = client["nasrium_db"]

db.players.update_one(
    {"user_id": "test123"},
    {"$set": {
        "user_id": "test123",
        "gold": 100,
        "gems": 10,
        "buildings": {"gold_mine": 3, "gem_drill": 1},
        "last_collect_time": time.time() - 3600,
        "speed_multiplier": 1.0
    }},
    upsert=True
)
print("Test player created/updated.")
