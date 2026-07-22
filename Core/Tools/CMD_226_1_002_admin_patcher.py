import os

print('[STEP 1] Creating AdminEngine.py...')
admin_code = """class AdminEngine:
    # این کلید باید محرمانه بماند. در نسخه نهایی در Environment Variable قرار میگیرد
    COMMANDER_SECRET_KEY = "NAXUS_SUPREME_CMD_MEHDI_2024"

    @staticmethod
    def verify_commander(key: str) -> bool:
        return key == AdminEngine.COMMANDER_SECRET_KEY

    @staticmethod
    def grant_resources(uid: int, resource_type: str, amount: int) -> dict:
        if resource_type not in ['gold', 'gems', 'nsm_soft', 'nsm_hard', 'troops']:
            return {'success': False, 'message': 'Invalid resource type'}
        return {'success': True, 'update': {'$inc': {resource_type: amount}}}

    @staticmethod
    def ban_target(uid: int) -> dict:
        return {'success': True, 'update': {'$set': {'is_banned': True, 'ban_reason': 'Commander Decree'}}}

    @staticmethod
    def unban_target(uid: int) -> dict:
        return {'success': True, 'update': {'$set': {'is_banned': False, 'ban_reason': ''}}}
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/AdminEngine.py', 'w', encoding='utf-8') as f: f.write(admin_code)
print('[OK] AdminEngine.py created')

print('[STEP 2] Patching mini_api.py with Commander Override endpoints...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()
    
    if 'from Core.App.AdminEngine import AdminEngine' not in content:
        content = 'from Core.App.AdminEngine import AdminEngine\n' + content

    if '/api/admin/grant' not in content:
        admin_api = '''
@app.route('/api/admin/grant', methods=['POST'])
def admin_grant():
    try:
        data = request.json; key = data.get('admin_key'); uid = data.get('user_id')
        res_type = data.get('resource_type'); amount = data.get('amount', 0)
        if not AdminEngine.verify_commander(key): return jsonify({'error': 'Unauthorized'}), 403
        if not uid: return jsonify({'error': 'Missing User ID'}), 400
        
        result = AdminEngine.grant_resources(uid, res_type, amount)
        if result['success']:
            players_collection.update_one({'user_id': uid}, result['update'])
            return jsonify({'success': True, 'message': f'Granted {amount} {res_type} to {uid}'})
        return jsonify(result), 400
    except Exception as e: return jsonify({'error': str(e)}), 500

@app.route('/api/admin/ban', methods=['POST'])
def admin_ban():
    try:
        data = request.json; key = data.get('admin_key'); uid = data.get('user_id'); action = data.get('action', 'ban')
        if not AdminEngine.verify_commander(key): return jsonify({'error': 'Unauthorized'}), 403
        if not uid: return jsonify({'error': 'Missing User ID'}), 400
        
        result = AdminEngine.ban_target(uid) if action == 'ban' else AdminEngine.unban_target(uid)
        if result['success']:
            players_collection.update_one({'user_id': uid}, result['update'])
            return jsonify({'success': True, 'message': f'User {uid} {action}ned by Commander'})
        return jsonify(result), 400
    except Exception as e: return jsonify({'error': str(e)}), 500
'''
        if 'app.run(host=' in content: content = content.replace('app.run(host=', admin_api + '\napp.run(host=', 1)

    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] Admin API Patched')

print('[STEP 3] Committing and pushing...')
