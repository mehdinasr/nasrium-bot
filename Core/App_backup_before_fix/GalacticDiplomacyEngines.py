class LunarColony:
    """ID_1019: استقرار اولین پایگاه دائمی بر روی قمر NSM."""
    CAPACITY = 50000 # نفر
    @staticmethod
    def establish_base():
        return "LUNAR_BASE_ALPHA_ESTABLISHED"

class SecondAirdrop:
    """ID_1020: توزیع پاداش بین دارندگان (Holders) توکن NSM."""
    @staticmethod
    def calculate_reward(nsm_balance):
        return nsm_balance * 0.05 # ۵٪ پاداش وفاداری

class DiplomaticCouncil:
    """ID_1021: شورای رسمی برای عقد قراردادهای بین-پروژه‌ای."""
    ACTIVE_TREATIES = []
    @staticmethod
    def sign_treaty(project_name):
        DiplomaticCouncil.ACTIVE_TREATIES.append(project_name)
        return f"Mutual Purity Pact signed with {project_name}."
