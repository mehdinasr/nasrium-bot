from mini_api import app
import os

if __name__ == "__main__":
    # اجرای سرور روی ای پی عمومی داخلی
    print("NASRIUM CORE: WAITING FOR MOBILE CONNECTION ON PORT 5000...")
    app.run(host='0.0.0.0', port=5000)
