# ADR-0001: NASRIUM Operating System (NOS)

## وضعیت
Accepted

## زمینه
برای جلوگیری از دوباره‌کاری و وابستگی به تاریخچه چت، پروژه باید «مغز وضعیت» و «سیستم گزارش/لاگ» روی دیسک داشته باشد.

## تصمیم
ایجاد ساختار Core شامل:
- Knowledge (Context + Handover + Project Book)
- Logs (Transcript + Logs)
- Reports (History)
- ADR (تصمیم‌های معماری)
- Archive (نسخه‌های قبلی Context)

## پیامدها
- ادامه پروژه در چت/اکانت جدید ممکن می‌شود
- ردیابی تغییرات و خطایابی سریع‌تر می‌شود
