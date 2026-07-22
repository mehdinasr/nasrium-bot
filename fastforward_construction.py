import os
from pymongo import MongoClient
import time

MONGO_URL = os.environ.get("MONGO_URL")
client = MongoClient(MONGO_URL)
db = client["nasrium_db"]

db.players.update_one(
    {"user_id": "test123"},
    {"$set": {"construction_until": time.time() - 10}}
)
print("Construction time fast-forwarded to the past.")
