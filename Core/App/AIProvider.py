import os
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
