import random
import time

class OracleEngine:
    @staticmethod
    def generate_forecast(market_index):
        # تولید پیش‌بینی‌های احتمالی بر اساس دیتای فعلی
        seed = int(time.time() / 3600) # تغییر هر ساعت
        random.seed(seed)
        
        forecasts = [
            {
                "topic": "Market Index",
                "prediction": "Inflation likely to drop" if market_index < 0.9 else "Stability expected",
                "confidence": random.randint(70, 95)
            },
            {
                "topic": "Leviathan Status",
                "prediction": "Anomaly detected in Sector 7",
                "confidence": random.randint(60, 85)
            },
            {
                "topic": "Syndicate Activity",
                "prediction": "High frequency encryption in Shadow Realm",
                "confidence": random.randint(50, 99)
            }
        ]
        return forecasts
