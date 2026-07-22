import time
import uuid

class MailEngine:
    @staticmethod
    def send_system_mail(db, user_id, subject, body, category="system"):
        mail_entry = {
            "mail_id": f"MAIL-{uuid.uuid4().hex[:6].upper()}",
            "user_id": user_id,
            "subject": subject,
            "body": body,
            "category": category, # system, combat, reward
            "is_read": False,
            "timestamp": time.time()
        }
        db.user_inbox.insert_one(mail_entry)
        return True

    @staticmethod
    def get_unread_count(db, user_id):
        return db.user_inbox.count_documents({"user_id": user_id, "is_read": False})

    @staticmethod
    def mark_as_read(db, mail_id):
        db.user_inbox.update_one({"mail_id": mail_id}, {"$set": {"is_read": True}})
        return True
