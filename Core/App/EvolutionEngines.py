class ExchangeEngine:
    """CMD_932: بازار آزاد برای تجارت مستقیم بین شهروندان."""
    MARKET_LISTINGS = [] # [{"seller_id": u_id, "item_id": i_id, "price": ixp}]

    @staticmethod
    def list_item(u_id, item_id, price):
        ExchangeEngine.MARKET_LISTINGS.append({"seller_id": u_id, "item_id": item_id, "price": price})
        return True, "Item listed in the Sovereign Exchange."

class AIAwakening:
    """CMD_933: بخشیدن شخصیت و دیالوگ به دستیاران AI."""
    PERSONALITIES = {
        "Aggressive": "Let's crush them in the Arena, Commander.",
        "Analytical": "Efficiency is at 98%. Mining is optimal.",
        "Supportive": "Your Empire is growing beautifully today."
    }

class GovernanceEngine:
    """CMD_934: سیستم رای‌دهی برای نخبگان (Sovereign Rank)."""
    ACTIVE_PROPOSALS = [
        {"id": 1, "desc": "Increase Mining Rate by 5%?", "votes_yes": 0, "votes_no": 0}
    ]

    @staticmethod
    def cast_vote(u_id, rank, prop_id, vote):
        if rank != "Sovereign":
            return False, "Only Sovereigns may participate in Clean Governance."
        # منطق ثبت رای
        return True, "Vote recorded in the Imperial Ledger."
