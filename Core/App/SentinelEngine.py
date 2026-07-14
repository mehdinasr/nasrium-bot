import random
import time

class SentinelEngine:
    @staticmethod
    def generate_challenge():
        # تولید یک الگوی عددی تصادفی برای تایید هویت
        pattern = [random.randint(1, 9) for _ in range(4)]
        challenge_id = int(time.time() * 1000)
        return {
            "id": challenge_id,
            "pattern": pattern,
            "sum": sum(pattern)
        }

    @staticmethod
    def verify_response(challenge_sum, user_input):
        # بررسی صحت پاسخ کاربر
        return int(user_input) == challenge_sum
