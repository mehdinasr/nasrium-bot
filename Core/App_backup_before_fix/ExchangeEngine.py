import random

class ExchangeEngine:
    # لیست سندیکاهای لیست شده در بورس {symbol: {name, price, change}}
    MARKET_DATA = {
        "ALPHA": {"name": "Alpha Vanguards", "price": 150.5, "change": 2.5},
        "PRIME": {"name": "Prime Cybernetics", "price": 85.0, "change": -1.2},
        "NOVA": {"name": "Nova Syndicate", "price": 210.0, "change": 5.8}
    }

    @staticmethod
    def update_prices():
        # شبیه‌سازی نوسانات بازار بر اساس فعالیت (ساده‌سازی شده)
        for sym in ExchangeEngine.MARKET_DATA:
            variation = random.uniform(-0.05, 0.06)
            ExchangeEngine.MARKET_DATA[sym]["price"] *= (1 + variation)
            ExchangeEngine.MARKET_DATA[sym]["change"] = variation * 100
        return ExchangeEngine.MARKET_DATA

    @staticmethod
    def trade_stock(player_data, symbol, amount, trade_type):
        stock = ExchangeEngine.MARKET_DATA.get(symbol)
        if not stock: return False, "Invalid Ticker Symbol."

        total_cost = int(stock["price"] * amount)
        portfolio = player_data.get("stock_portfolio", {})

        if trade_type == "BUY":
            if player_data.get("nsm_soft", 0) < total_cost:
                return False, "Insufficient liquidity for this acquisition."
            player_data["nsm_soft"] -= total_cost
            portfolio[symbol] = portfolio.get(symbol, 0) + amount
        elif trade_type == "SELL":
            if portfolio.get(symbol, 0) < amount:
                return False, "Insufficient shares in your portfolio."
            player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + total_cost
            portfolio[symbol] -= amount
        
        player_data["stock_portfolio"] = portfolio
        return True, f"Trade Confirmed: {trade_type} {amount} shares of {symbol}."
