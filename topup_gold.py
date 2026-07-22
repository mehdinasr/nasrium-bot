import os
from pymongo import MongoClient

MONGO_URL = os.environ.get("MONGO_URL")
client = MongoClient(MONGO_URL)
db = client["nasrium_db"]

db.players.update_one(
    {"user_id": "test123"},
    {"$set": {"gold": 5000, "is_building": False}}
)
print("Test player gold topped up.")
