import random
import time

class DecipherEngine:
    """
    تولید و تایید چالش‌های حافظه و سرعت برای شهروندان.
    """
    @staticmethod
    def generate_puzzle(level=1):
        # تولید یک توالی تصادفی از اعداد (طول توالی بر اساس سطح)
        sequence_length = 3 + level
        sequence = [random.randint(1, 9) for _ in range(sequence_length)]
        return {
            "sequence": sequence,
            "timer": 10 + (level * 2), # زمان محدود برای هر چالش
            "reward": 200 * level
        }

    @staticmethod
    def verify_solution(player_data, user_sequence, target_sequence, level):
        if user_sequence == target_sequence:
            reward = 200 * level
            player_data["intel_xp"] += reward
            return True, f"Decryption Successful! +{reward} IXP infused."
        return False, "Decryption Failed. Sequence mismatch."
