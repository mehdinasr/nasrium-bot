import time

class SupportEngine:
    """
    مدیریت دادخواست‌ها و تیکت‌های پشتیبانی شهروندان.
    """
    TICKETS = [] # ذخیره تیکت‌ها در حافظه (در نسخه نهایی به دیتابیس منتقل می‌شود)

    @staticmethod
    def submit_petition(u_id, category, message):
        if not message or len(message) < 10:
            return False, "Petition too brief. Explain your grievance."
        
        ticket_id = len(SupportEngine.TICKETS) + 1
        petition = {
            "id": ticket_id,
            "user_id": u_id,
            "category": category,
            "message": message,
            "status": "OPEN", # OPEN, UNDER_REVIEW, RESOLVED
            "timestamp": time.strftime("%Y-%m-%d %H:%M")
        }
        SupportEngine.TICKETS.append(petition)
        return True, f"Petition #{ticket_id} received by the Bureau."

    @staticmethod
    def get_user_petitions(u_id):
        return [t for t in SupportEngine.TICKETS if t["user_id"] == u_id]
