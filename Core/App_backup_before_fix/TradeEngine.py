import time

class TradeEngine:
    # لیست پیمان‌های فعال {pact_id: {fed_a, fed_b, expiry}}
    ACTIVE_PACTS = {}

    @staticmethod
    def propose_pact(sender_fed, target_fed):
        # هزینه دیپلماسی: 50,000 طلا از خزانه فدراسیون (CMD_470)
        pact_id = f"PACT-{sender_fed}-{target_fed}"
        TradeEngine.ACTIVE_PACTS[pact_id] = {
            "parties": [sender_fed, target_fed],
            "fee_reduction": 0.80, # ۸۰٪ تخفیف در کارمزد (از ۱۰٪ به ۲٪)
            "expiry": time.time() + 259200 # ۷۲ ساعت اعتبار
        }
        return True, f"Economic Silk Road established between {sender_fed} and {target_fed}."

    @staticmethod
    def is_allied_trade(fed_a, fed_b):
        # بررسی اینکه آیا دو فدراسیون پیمان فعال دارند
        for p in TradeEngine.ACTIVE_PACTS.values():
            if fed_a in p["parties"] and fed_b in p["parties"]:
                if time.time() < p["expiry"]: return True
        return False
