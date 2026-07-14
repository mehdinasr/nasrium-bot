import time

class RadioEngine:
    # آرشیو اخبار و اعلانات {id: {text, priority}}
    NEWS_FEED = [
        {"id": 1, "text": "نصریوم: عصر گسترش کهکشانی آغاز شد.", "priority": "HIGH"},
        {"id": 2, "text": "فرمانده مهدی: مرزهای امپراتوری نفوذناپذیر است.", "priority": "ULTRA"}
    ]

    @staticmethod
    def get_latest_broadcast():
        # بازگرداندن متن برای نوار متحرک رادیو
        combined_news = " | ". join([n["text"] for n in RadioEngine.NEWS_FEED])
        return combined_news

    @staticmethod
    def post_emergency_broadcast(text):
        new_id = len(RadioEngine.NEWS_FEED) + 1
        RadioEngine.NEWS_FEED.insert(0, {"id": new_id, "text": text, "priority": "EMERGENCY"})
        if len(RadioEngine.NEWS_FEED) > 10: RadioEngine.NEWS_FEED.pop()
        return True
