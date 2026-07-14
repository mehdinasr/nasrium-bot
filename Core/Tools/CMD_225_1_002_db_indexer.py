import os

print('[STEP 1] Enforcing Database Indexes for query performance...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()
    
    # LAW 6: Every Module is independent and reusable. LAW 9: Avoid duplicated code.
    if 'def initialize_db_indexes():' not in content:
        index_func = '''
def initialize_db_indexes():
    try:
        players_collection.create_index([("user_id", 1)], unique=True)
        players_collection.create_index([("clan_id", 1)])
        players_collection.create_index([("shield_active_until", 1)])
        clans_collection.create_index([("clan_id", 1)], unique=True)
        print("[DB] Indexes verified/created.")
    except Exception as e:
        print(f"[DB] Index creation warning: {e}")

'''
        # تزریق تابع به فایل
        if 'def initialize_db_indexes():' not in content:
             content = index_func + content
        
        # فراخوانی تابع در شروع برنامه
        if 'initialize_db_indexes()' not in content:
            content = content.replace('if __name__ ==', 'initialize_db_indexes()\n\nif __name__ ==', 1)

        with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
        print('[OK] DB Indexing logic injected into API')

print('[STEP 2] Committing and pushing...')
