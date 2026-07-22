import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.SyndicateEngine import SyndicateEngine" not in content:
    content = "from Core.App.SyndicateEngine import SyndicateEngine\n" + content
    print("[OK] SyndicateEngine imported.")

# اضافه کردن روت ثبت زیرمجموعه
referral_endpoint = '''
@app.route("/api/user/register", methods=["POST"])
def register_user():
    try:
        data = request.json
        uid = data.get("user_id")
        upline_id = data.get("upline_id")
        if not uid: return jsonify({"error": "User ID required"}), 400

        # ثبت کاربر جدید و ثبت سرگروه او
        existing_user = players_collection.find_one({"user_id": uid})
        if not existing_user:
            default_data = {
                "user_id": uid,
                "upline_id": upline_id if upline_id else None,
                "gold": 1000, "gems": 10, "nsm_soft": 5, "nsm_hard": 0,
                "town_hall_level": 1, "is_nexus_maxed": False, "is_banned": False,
                "buildings": {"gold_mine": 1, "gem_drill": 0}
            }
            players_collection.insert_one(default_data)
            return jsonify({"success": True, "message": "User registered with Upline"})
        else:
            return jsonify({"success": True, "message": "User already exists"})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/user/register" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", referral_endpoint + "\napp.run(host=", 1)
        print("[OK] Referral API endpoint injected.")

# هک امن: تزریق کد پورسانت به داخل تابع برداشت قدیمی
if "SyndicateEngine.process_upline_commission" not in content:
    # پیدا کردن خط آپدیت دیتابیس در تابع withdraw و اضافه کردن محاسبه پورسانت بعد از آن
    old_withdraw_update = 'players_collection.update_one(\n                {"user_id": uid},\n                {"$set": {"nsm_hard": result["new_nsm_hard_balance"]}}\n            )\n            return jsonify(result)'
    new_withdraw_update = '''players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard_balance"]}}
            )
            # محاسبه و توزیع خودکار پورسانت سرگروه (Syndicate Commission)
            if result.get("actual_payout", 0) > 0:
                SyndicateEngine.process_upline_commission(uid, result["actual_payout"], players_collection)
            return jsonify(result)'''
    
    content = content.replace(old_withdraw_update, new_withdraw_update)
    print("[OK] Syndicate Commission logic injected into Withdrawal endpoint.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
