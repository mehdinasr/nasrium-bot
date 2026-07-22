import os

print('[STEP 1] Creating DepositEngine.py...')
deposit_code = """class DepositEngine:
    # Project TON Wallet Address
    PROJECT_TON_WALLET = "UQD...YOUR_PROJECT_WALLET_ADDRESS"

    # Exchange Rate: 1 TON = 100 NSM_Hard
    EXCHANGE_RATE = 100 

    @staticmethod
    def get_deposit_info(user_id: int) -> dict:
        return {
            'wallet_address': DepositEngine.PROJECT_TON_WALLET,
            'memo': str(user_id),
            'exchange_rate': DepositEngine.EXCHANGE_RATE,
            'instructions': 'Send TON to the address above. You MUST include your Telegram ID in the Memo/Comment field.'
        }

    @staticmethod
    def calculate_nsm_hard(ton_amount: float) -> int:
        return int(ton_amount * DepositEngine.EXCHANGE_RATE)
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/DepositEngine.py', 'w', encoding='utf-8') as f: f.write(deposit_code)
print('[OK] DepositEngine.py created')

print('[STEP 2] Patching mini_api.py with Deposit & Admin Approve endpoints...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()
    
    if 'from Core.App.DepositEngine import DepositEngine' not in content:
        content = 'from Core.App.DepositEngine import DepositEngine\n' + content

    if '/api/ton/deposit_info' not in content:
        deposit_api = """
@app.route('/api/ton/deposit_info', methods=['GET'])
def get_deposit_info():
    try:
        uid = int(request.args.get('user_id'))
        if not uid: return jsonify({'error': 'Missing ID'}), 400
        info = DepositEngine.get_deposit_info(uid)
        return jsonify(info)
    except Exception as e: return jsonify({'error': str(e)}), 500

@app.route('/api/admin/approve_deposit', methods=['POST'])
def admin_approve_deposit():
    try:
        data = request.json; key = data.get('admin_key'); uid = data.get('user_id')
        ton_amount = data.get('ton_amount', 0)
        if not AdminEngine.verify_commander(key): return jsonify({'error': 'Unauthorized'}), 403
        if not uid or ton_amount <= 0: return jsonify({'error': 'Invalid data'}), 400
        
        nsm_hard_to_add = DepositEngine.calculate_nsm_hard(ton_amount)
        players_collection.update_one({'user_id': uid}, {'$inc': {'nsm_hard': nsm_hard_to_add}})
        NotificationEngine.add_notification(uid, f'Deposit Confirmed! +{nsm_hard_to_add} NSM_Hard credited.', 'deposit', players_collection)
        return jsonify({'success': True, 'message': f'Added {nsm_hard_to_add} NSM_Hard to user {uid}'})
    except Exception as e: return jsonify({'error': str(e)}), 500
"""
        if 'app.run(host=' in content: content = content.replace('app.run(host=', deposit_api + '\napp.run(host=', 1)

    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] API Patched')

print('[STEP 3] Committing and pushing...')
