path = 'mini_api.py'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'from Core.App.PublicLaunchEngine import PublicLaunchEngine' not in content:
    content = "from Core.App.PublicLaunchEngine import PublicLaunchEngine\n" + content

launch_api = """
@app.route('/api/launch/awaken', methods=['POST'])
def public_awaken():
    data = request.json
    u_id = data.get('user_id')
    player = PlayerRepository.get_player(u_id)
    success, msg = PublicLaunchEngine.process_new_citizen(player)
    if success:
        PlayerRepository.create_or_update_player(player)
        PlayerRepository.add_log(u_id, "LAUNCH: Joined as Genesis Citizen.")
    return jsonify({'success': success, 'message': msg})

@app.route('/api/launch/info', methods=['GET'])
def launch_info():
    return jsonify({'success': True, 'data': PublicLaunchEngine.get_launch_stats()})
"""

if '/api/launch/awaken' not in content:
    content = content.replace("if __name__ == '__main__':", launch_api + "\nif __name__ == '__main__':")

with open(path, 'w', encoding='utf-8') as f: f.write(content)
print('[OK] Public Entry API Activated.')
