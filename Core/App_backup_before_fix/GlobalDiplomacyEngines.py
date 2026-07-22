class GlobalDiplomacyEngine:
    """مدیریت قراردادها و اتحادهای رسمی با پروژه های خارجی."""
    TREATIES = []
    @staticmethod
    def sign_treaty(project_id, terms_hash):
        GlobalDiplomacyEngine.TREATIES.append({"project": project_id, "terms": terms_hash})
        return True

class DCDNEngine:
    """شبکه توزیع محتوای غیرمتمرکز برای سرعت بخشیدن به تمدن."""
    @staticmethod
    def get_fastest_node(user_region):
        return f"DCDN_NODE_{user_region}_STABLE"
