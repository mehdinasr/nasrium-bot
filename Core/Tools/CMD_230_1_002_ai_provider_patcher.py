import os

print('[STEP 1] Creating AIProvider.py...')
ai_code = """import os
import json
import urllib.request
import urllib.error

class AIProvider:
    # API Key should be set in Environment Variables for security in production
    API_KEY = os.environ.get('OPENAI_API_KEY', 'YOUR_OPENAI_API_KEY_HERE')
    API_URL = 'https://api.openai.com/v1/chat/completions'
    MODEL = 'gpt-3.5-turbo'

    @staticmethod
    def generate_response(system_prompt: str, user_message: str, lang: str = 'en') -> str:
        if AIProvider.API_KEY == 'YOUR_OPENAI_API_KEY_HERE':
            return f'[NAXUS Offline Mode] I received your query: "{user_message}". API Key not configured.'

        headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {AIProvider.API_KEY}'
        }

        messages = [
            {'role': 'system', 'content': system_prompt},
            {'role': 'user', 'content': user_message}
        ]

        data = {
            'model': AIProvider.MODEL,
            'messages': messages,
            'max_tokens': 500,
            'temperature': 0.7
        }

        try:
            req = urllib.request.Request(
                AIProvider.API_URL,
                data=json.dumps(data).encode('utf-8'),
                headers=headers,
                method='POST'
            )
            with urllib.request.urlopen(req, timeout=15) as response:
                result = json.loads(response.read().decode('utf-8'))
                return result['choices'][0]['message']['content']
        except urllib.error.URLError as e:
            return f'AI Connection Error: {str(e)}'
        except Exception as e:
            return f'AI Processing Error: {str(e)}'
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/AIProvider.py', 'w', encoding='utf-8') as f: f.write(ai_code)
print('[OK] AIProvider.py created')

print('[STEP 2] Upgrading NAXUSCore.py to use AIProvider...')
nexus_code = """from Core.App.AIProvider import AIProvider

class NAXUSAssistant:
    RULEBOOK_EN = "You are NAXUS, the supreme AI assistant of the NASRIUM Cyber-Empire. Answer user questions about the game rules, economy, and strategy based on the context provided. Be concise and helpful."
    RULEBOOK_FA = "شما ناکسوس هستید دستیار هوشمند امپراتوری سایبری ناسریوم. به سوالات کاربر درباره قوانین بازی اقتصاد و استراتی بر اساس متن داده شده پاسخ دهید."

    TIER_FREE = "Free"
    TIER_PREMIUM = "Premium"

    def __init__(self, user_id: int, player_data: dict, lang: str = "en"):
        self.user_id = user_id
        self.player_data = player_data
        self.lang = lang
        self.tier = self.TIER_PREMIUM if player_data.get("nsm_hard", 0) > 50 else self.TIER_FREE
        self.is_commander = False

    def ask_guide(self, query: str) -> str:
        # Construct context based on player data
        context = f"Player Level: {self.player_data.get('town_hall_level', 1)}. Wallet Active: {self.player_data.get('wallet_active', False)}. Subscription: {self.tier}."
        
        system_prompt = self.RULEBOOK_FA if self.lang == "fa" else self.RULEBOOK_EN
        system_prompt += f" Player Context: {context}"
        
        if self.lang == "fa":
            system_prompt += " If the user asks about attacks or strategy and they are Premium, provide advanced strategy. If they are Free, tell them to upgrade."
        else:
            system_prompt += " If the user asks about attacks or strategy and they are Premium, provide advanced strategy. If they are Free, tell them to upgrade."

        # Call LLM
        response = AIProvider.generate_response(system_prompt, query, self.lang)
        return response

    def execute_commander_override(self, command: str) -> str:
        if not self.is_commander: return "Unauthorized."
        return f"[Commander Mode]: Executing {command}"
"""
with open('Core/App/NAXUSCore.py', 'w', encoding='utf-8') as f: f.write(nexus_code)
print('[OK] NAXUSCore.py upgraded with LLM logic')

print('[STEP 3] Committing and pushing...')
