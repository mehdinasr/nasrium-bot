import time

class MessengerEngine:
    # حافظه موقت پیام‌ها (در نسخه نهایی در MongoDB ذخیره می‌شود)
    PRIVATE_DATABASE = {} # {user_id: [messages]}

    @staticmethod
    def send_direct_message(sender_data, receiver_id, text):
        if sender_data["user_id"] == receiver_id:
            return False, "You cannot relay signals to yourself."
        
        msg_obj = {
            "id": int(time.time() * 1000),
            "sender": sender_data["user_id"],
            "text": text,
            "time": time.strftime("%m/%d %H:%M"),
            "read": False
        }

        # ثبت در صندوق ورودی گیرنده
        if receiver_id not in MessengerEngine.PRIVATE_DATABASE:
            MessengerEngine.PRIVATE_DATABASE[receiver_id] = []
        
        MessengerEngine.PRIVATE_DATABASE[receiver_id].append(msg_obj)
        
        # محدودیت صندوق ورودی: ۳۰ پیام آخر
        if len(MessengerEngine.PRIVATE_DATABASE[receiver_id]) > 30:
            MessengerEngine.PRIVATE_DATABASE[receiver_id].pop(0)
            
        return True, "Signal relayed through Sovereign Bridge."

    @staticmethod
    def get_inbox(user_id):
        return MessengerEngine.PRIVATE_DATABASE.get(user_id, [])
