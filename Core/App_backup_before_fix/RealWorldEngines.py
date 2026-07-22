class RealWorldBridge:
    """ID_1281: مدیریت تراکنش های خرید کالای فیزیکی با NSM."""
    @staticmethod
    def process_physical_order(u_id, item_id, price_nsm):
        return f"ORDER_PLACED: {item_id} FOR USER {u_id}"

class SovereignDebitCard:
    """ID_1282: صدور کارت های اعتباری متصل به موجودی NSM."""
    @staticmethod
    def issue_card(u_id, credit_limit):
        return {"card_id": f"NSM-CARD-{u_id[:5]}", "limit": credit_limit}
