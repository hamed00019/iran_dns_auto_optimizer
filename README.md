<div align="center">

# 🚀 DNS Optimizer
### بهینه‌ساز هوشمند و امن DNS برای سیستم‌های لینوکس

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Language-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.linux.org/)

</div>

---

## 📖 درباره پروژه

**DNS Optimizer** یک ابزار قدرتمند و امن برای پیدا کردن سریع‌ترین سرورهای DNS و تنظیم خودکار آن‌ها در سیستم‌های لینوکس است. این ابزار با در نظر گرفتی بهترین شیوه‌های امنیتی و عملکردی طراحی شده تا تجربه اینترنت شما را بهبود بخشد.

### 🎯 هدف پروژه
- **بهبود سرعت اینترنت** با انتخاب بهترین سرورهای DNS
- **افزایش امنیت** با استفاده از سرورهای DNS معتبر
- **خودکارسازی** فرآیند بهینه‌سازی DNS
- **سادگی استفاده** برای تمام کاربران

---

## ✨ ویژگی‌های کلیدی

<table>
<tr>
<td width="50%">

### 🔒 امنیت بالا
- بدون استفاده از دستورات خطرناک
- محافظت در برابر حملات Race Condition
- مدیریت امن فایل‌های موقت
- کنترل دسترسی‌های سیستمی

### ⚡ عملکرد بهینه
- تست موازی سرورهای DNS
- کنترل هوشمند منابع سیستم
- الگوریتم‌های بهینه‌سازی پیشرفته
- گزارش‌دهی دقیق عملکرد

</td>
<td width="50%">

### 🌐 سازگاری گسترده
- پشتیبانی از تمام توزیع‌های اصلی لینوکس
- سازگاری با systemd-resolved
- مدیریت خودکار /etc/resolv.conf
- شناسایی هوشمند محیط سیستم

### 🛠️ مدیریت آسان
- فایل کانفیگ قابل تنظیم
- پشتیبان‌گیری خودکار
- سیستم لاگ پیشرفته
- رابط کاربری ساده

</td>
</tr>
</table>

---

## 🚀 نصب سریع

### نصب با یک دستور
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hamed00019/iran_dns_auto_optimizer/main/install.sh)"
```

### نصب دستی
```bash
# دانلود فایل‌ها
git clone https://github.com/hamed00019/iran_dns_auto_optimizer.git
cd iran_dns_auto_optimizer

# اجرای اسکریپت نصب
sudo bash install.sh
```

> **نکته:** برای نصب به دسترسی sudo نیاز دارید

---

## 📚 راهنمای استفاده

### دستورات اصلی

| دستور | شرح | مثال |
|--------|------|-------|
| `run` | بهینه‌سازی استاندارد (پیش‌فرض) | `sudo dns-optimizer run` |
| `quick` | بهینه‌سازی سریع | `sudo dns-optimizer quick` |
| `full` | بهینه‌سازی کامل | `sudo dns-optimizer full` |
| `status` | نمایش وضعیت فعلی | `dns-optimizer status` |
| `restore` | بازگردانی تنظیمات قبلی | `sudo dns-optimizer restore` |
| `log [N]` | نمایش لاگ‌ها | `dns-optimizer log 50` |
| `config` | ویرایش تنظیمات | `sudo dns-optimizer config` |
| `help` | راهنمای کامل | `dns-optimizer help` |

### مثال‌های کاربردی

```bash
# اجرای بهینه‌سازی سریع
sudo dns-optimizer quick

# بررسی وضعیت DNS فعلی
dns-optimizer status

# مشاهده آخرین لاگ‌ها
dns-optimizer log 30

# بازگردانی در صورت مشکل
sudo dns-optimizer restore
```

---

## ⚙️ تنظیمات پیشرفته

### فایل کانفیگ
تمام تنظیمات در فایل `/etc/dns-optimizer.conf` قابل تغییر است:

```bash
# ویرایش تنظیمات
sudo dns-optimizer config
```

### پارامترهای مهم

| پارامتر | پیش‌فرض | توضیح |
|---------|---------|-------|
| `MAX_RESPONSE_TIME` | 1500ms | حداکثر زمان پاسخ قابل قبول |
| `MIN_SUCCESS_RATE` | 60% | حداقل درصد موفقیت |
| `TOP_DNS_COUNT` | 4 | تعداد بهترین DNS‌ها |
| `PARALLEL_JOBS` | خودکار | تعداد پردازش‌های موازی |

### سرورهای DNS پشتیبانی شده

<details>
<summary>🇮🇷 سرورهای داخلی ایران</summary>

- **Shecan**: `185.51.200.2`, `178.22.122.100`
- **Asiatech**: `194.5.175.100`, `194.5.175.101`
- **ITC**: `5.202.100.100`, `5.202.100.101`
- **و بیش از 20 سرور دیگر...**

</details>

<details>
<summary>🌍 سرورهای بین‌المللی</summary>

- **Cloudflare**: `1.1.1.1`, `1.0.0.1`
- **Google**: `8.8.8.8`, `8.8.4.4`
- **Quad9**: `9.9.9.9`, `149.112.112.112`
- **و سرورهای معتبر دیگر...**

</details>

---

## 🔄 اجرای خودکار

DNS Optimizer به صورت خودکار هر 12 ساعت اجرا می‌شود تا DNS‌های شما همیشه بهینه باشند.

### مدیریت سرویس
```bash
# بررسی وضعیت تایمر
systemctl status dns-optimizer.timer

# غیرفعال کردن اجرای خودکار
sudo systemctl disable dns-optimizer.timer

# فعال کردن مجدد
sudo systemctl enable --now dns-optimizer.timer
```

---

## 📊 نمونه خروجی

```
🧪 Testing 25 servers against 8 domains...
📊 Analyzing results...

🏆 Top DNS Servers:
  Shecan-Primary        (185.51.200.2) - 45ms avg, 95% success
  Cloudflare-Primary    (1.1.1.1) - 52ms avg, 98% success
  Google-Primary        (8.8.8.8) - 58ms avg, 92% success
  Asiatech-Primary      (194.5.175.100) - 61ms avg, 88% success

✅ DNS settings have been updated.
```

---

## 🛠️ عیب‌یابی

### مشکلات رایج

<details>
<summary>❌ خطای دسترسی</summary>

```bash
# اطمینان از اجرا با sudo
sudo dns-optimizer run

# بررسی مجوزهای فایل
ls -la /etc/dns-optimizer.conf
```

</details>

<details>
<summary>🔍 بررسی لاگ‌ها</summary>

```bash
# مشاهده لاگ‌های اخیر
dns-optimizer log 50

# مشاهده لاگ کامل
sudo tail -f /var/log/dns-optimizer.log
```

</details>

<details>
<summary>🔄 بازگردانی تنظیمات</summary>

```bash
# بازگردانی به حالت قبل
sudo dns-optimizer restore

# بررسی تنظیمات فعلی
dns-optimizer status
```

</details>

---

## 🗑️ حذف نرم‌افزار

برای حذف کامل DNS Optimizer:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hamed00019/iran_dns_auto_optimizer/main/install.sh)" -- uninstall
```

این دستور تمام فایل‌ها، سرویس‌ها و تنظیمات را به طور کامل پاک می‌کند.

---

## 🤝 مشارکت

### نحوه مشارکت
1. **Fork** کردن پروژه
2. ایجاد **branch** جدید (`git checkout -b feature/amazing-feature`)
3. **Commit** تغییرات (`git commit -m 'Add amazing feature'`)
4. **Push** به branch (`git push origin feature/amazing-feature`)
5. ایجاد **Pull Request**

### گزارش باگ
برای گزارش مشکلات از [Issues](https://github.com/hamed00019/iran_dns_auto_optimizer/issues) استفاده کنید.

---

## 📄 مجوز

این پروژه تحت مجوز MIT منتشر شده است. برای اطلاعات بیشتر فایل [LICENSE](LICENSE) را مطالعه کنید.

---

## 🙏 تشکر

- از تمام کسانی که در توسعه این پروژه مشارکت داشته‌اند
- از ارائه‌دهندگان سرویس DNS که خدمات رایگان ارائه می‌دهند
- از جامعه متن‌باز که الهام‌بخش این پروژه بوده‌اند

---

<div align="center">

### ⭐ اگر این پروژه برایتان مفید بود، لطفاً ستاره دهید!

**ساخته شده با ❤️ برای جامعه ایرانی**

</div>
