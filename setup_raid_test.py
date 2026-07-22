import os
from pymongo import MongoClient

MONGO_URL = os.environ.get("MONGO_URL")
client = MongoClient(MONGO_URL)
db = client["nasrium_db"]

db.players.update_one(
    {"user_id": "test123"},
    {"$set": {"troops": 50, "gold": 5000}}
)

db.players.update_one(
    {"user_id": "victim456"},
    {"$set": {
        "user_id": "victim456",
        "gold": 2000, "gems": 100, "troops": 5,
        "town_hall_level": 1, "shield_active_until": 0, "nsm_hard": 20
    }},
    upsert=True
)
print("Test players ready.")
