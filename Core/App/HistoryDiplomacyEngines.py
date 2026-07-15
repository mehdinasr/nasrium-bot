class GalacticHeritage:
    """ID_1111: ثبت سوابق تاریخی لژیون ها بر روی دیتابیس ابدی."""
    LEGION_HISTORY = {} # {l_name: [events]}
    @staticmethod
    def record_achievement(l_name, achievement):
        if l_name not in GalacticHeritage.LEGION_HISTORY:
            GalacticHeritage.LEGION_HISTORY[l_name] = []
        GalacticHeritage.LEGION_HISTORY[l_name].append(achievement)

class EmbargoProtocols:
    """ID_1113: محدودسازی فعالیت تجاری برای کاربران یا لژیون های خاطی."""
    @staticmethod
    def check_embargo(u_id):
        # بررسی وضعیت تحریم از طرف خالق
        return False
