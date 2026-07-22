import hmac
import hashlib
import json
import urllib.parse
import os

class AuthEngine:
    BOT_TOKEN = os.environ.get('TELEGRAM_BOT_TOKEN', 'YOUR_BOT_TOKEN_HERE')

    @staticmethod
    def verify_telegram_data(init_data):
        # بررسی صحت داده‌های ارسالی از تلگرام (بر اساس الگوریتم HMAC)
        if AuthEngine.BOT_TOKEN == 'YOUR_BOT_TOKEN_HERE':
            return True # در حالت توسعه بدون توکن تایید می‌شود
            
        try:
            parsed_data = dict(urllib.parse.parse_qsl(init_data))
            hash_str = parsed_data.pop('hash', '')
            data_check_string = "\n".join([f"{k}={v}" for k, v in sorted(parsed_data.items())])
            
            secret_key = hmac.new(b"WebAppData", AuthEngine.BOT_TOKEN.encode(), hashlib.sha256).digest()
            calculated_hash = hmac.new(secret_key, data_check_string.encode(), hashlib.sha256).hexdigest()
            
            return calculated_hash == hash_str
        except:
            return False

    @staticmethod
    def extract_user(init_data):
        try:
            parsed_data = dict(urllib.parse.parse_qsl(init_data))
            user_data = json.loads(parsed_data.get('user', '{}'))
            return user_data
        except:
            return None
