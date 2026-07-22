import time

class ChronosEngine:
    # مبدأ تاریخ نصریوم (زمان تقریبی گام ۵۰۰)
    GENESIS_TIMESTAMP = 1720994400 # ژوئیه ۲۰۲۶
    
    # ضریب زمان: هر ۷ روز واقعی = ۱ سال امپراتوری
    SECONDS_PER_IMPERIAL_YEAR = 604800 

    @staticmethod
    def get_current_date():
        elapsed = time.time() - ChronosEngine.GENESIS_TIMESTAMP
        year = int(elapsed / ChronosEngine.SECONDS_PER_IMPERIAL_YEAR) + 1
        
        # محاسبه عصر (Era)
        era = "Era of Awakening"
        if year > 10: era = "Era of Expansion"
        if year > 50: era = "Era of Sovereignty"
        
        return {
            "year": year,
            "era": era,
            "raw_elapsed": int(elapsed)
        }
