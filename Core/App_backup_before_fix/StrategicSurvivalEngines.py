import time

class SurvivalLogic:
    """ID_1054: مدیریت اکسیژن و بقا در سیارات تسخیر شده."""
    @staticmethod
    def get_oxygen_levels(player_data):
        last_refill = player_data.get("last_oxygen_sync", time.time())
        elapsed = time.time() - last_refill
        # کاهش 1 درصد اکسیژن در هر 10 دقیقه
        current_ox = max(0, 100 - int(elapsed / 600))
        return current_ox

class LegionHighCommand:
    """ID_1055: کنسول مدیریتی برای رهبران فدراسیون."""
    DIRECTIVES = {} # {federation_name: current_objective}
    
    @staticmethod
    def issue_directive(fed_name, objective):
        LegionHighCommand.DIRECTIVES[fed_name] = objective
        return True, f"High Command Directive issued: {objective}"

class ResourceRefinery:
    """ID_1056: تصفیه خانه برای تبدیل منابع سیاره ای به NSM."""
    @staticmethod
    def refine_resources(raw_amount, efficiency_level):
        # نرخ تبدیل پایه: 10 به 1
        refined = (raw_amount / 10) * (1.0 + (efficiency_level * 0.05))
        return int(refined)
