import time

class ChatEngine:
    # بافرهای حافظه برای چت (در نسخه نهایی در Redis یا DB ذخیره می‌شود)
    GLOBAL_BUFFER = []
    SYNDICATE_BUFFERS = {} # {syn_name: [messages]}

    @staticmethod
    def post_message(player_data, text, channel="global"):
        msg_obj = {
            "id": int(time.time() * 1000),
            "sender": player_data["user_id"],
            "text": text,
            "time": time.strftime("%H:%M"),
            "role": player_data.get("active_title", "Citizen")
        }

        if channel == "global":
            ChatEngine.GLOBAL_BUFFER.append(msg_obj)
            if len(ChatEngine.GLOBAL_BUFFER) > 50: ChatEngine.GLOBAL_BUFFER.pop(0)
        else:
            syn_name = player_data.get("syndicate")
            if not syn_name: return False, "No Syndicate."
            if syn_name not in ChatEngine.SYNDICATE_BUFFERS:
                ChatEngine.SYNDICATE_BUFFERS[syn_name] = []
            ChatEngine.SYNDICATE_BUFFERS[syn_name].append(msg_obj)
            if len(ChatEngine.SYNDICATE_BUFFERS[syn_name]) > 50: ChatEngine.SYNDICATE_BUFFERS[syn_name].pop(0)
        
        return True, "Message transmitted."

    @staticmethod
    def fetch_messages(player_data, channel="global"):
        if channel == "global":
            return ChatEngine.GLOBAL_BUFFER
        else:
            syn_name = player_data.get("syndicate")
            return ChatEngine.SYNDICATE_BUFFERS.get(syn_name, [])
