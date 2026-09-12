import '../config/app_config.dart';

abstract final class LegalContent {
  static List<String> terms(String languageCode) {
    return switch (languageCode) {
      'ku' => _termsKu,
      'ar' => _termsAr,
      _ => _termsEn,
    };
  }

  static List<String> privacy(String languageCode) {
    final email = AppConfig.supportEmail;
    final base = switch (languageCode) {
      'ku' => _privacyKuBase,
      'ar' => _privacyArBase,
      _ => _privacyEnBase,
    };
    return [...base, _privacyContact(languageCode, email)];
  }

  static List<String> supportFaq(String languageCode) {
    return switch (languageCode) {
      'ku' => _faqKu,
      'ar' => _faqAr,
      _ => _faqEn,
    };
  }

  static const _termsEn = [
    'By using eSIM KRD you agree to these terms. eSIM KRD sells prepaid mobile data plans delivered digitally as eSIM profiles.',
    'Plans are provided through third-party carriers. Coverage, speed, and availability depend on the local network. We do not guarantee service in every location.',
    'Prices are shown in USD with an approximate IQD equivalent. The final IQD amount is calculated at checkout using the current exchange rate.',
    'After successful payment, your eSIM is delivered in the app. Installation requires a compatible unlocked device with eSIM support.',
    'Refunds are handled case by case. If provisioning fails, we will refund or replace the order. Contact support with your order number.',
    'We may update these terms. Continued use of the app after changes means you accept the updated terms.',
  ];

  static const _termsAr = [
    'باستخدام eSIM KRD فإنك توافق على هذه الشروط. يبيع eSIM KRD باقات بيانات مسبقة الدفع تُسلَّم رقمياً كشرائح eSIM.',
    'الباقات مقدَّمة عبر مشغّلين خارجيين. التغطية والسرعة تعتمد على الشبكة المحلية. لا نضمن الخدمة في كل موقع.',
    'الأسعار معروضة بالدولار مع ما يعادلها بالدينار. المبلغ النهائي بالدينار يُحسب عند الدفع وفق سعر الصرف الحالي.',
    'بعد الدفع الناجح، تُسلَّم الشريحة داخل التطبيق. التثبيت يتطلب جهازاً متوافقاً ومفتوح الشبكة يدعم eSIM.',
    'الاسترداد يُعالَج حسب الحالة. إذا فشل التفعيل، نسترد المبلغ أو نستبدل الطلب. تواصل مع الدعم مع رقم الطلب.',
    'قد نحدّث هذه الشروط. الاستمرار في استخدام التطبيق بعد التغييرات يعني قبول الشروط المحدّثة.',
  ];

  static const _termsKu = [
    'بە بەکارهێنانی eSIM KRD ڕازی دەبیت لەم مەرجەکان. eSIM KRD پلانی داتای پێشوەختە فرۆشت دەکات کە وەک eSIM دیجیتاڵی دەگەیەنرێت.',
    'پلانەکان لە ڕێگەی کۆمپانیای تۆڕی دەرەکی دابین دەکرێن. داپۆشین و خێرایی پشت بە تۆڕی ناوخۆیی دەبەستێت.',
    'نرخەکان بە USD پیشان دەدرێن لەگەڵ IQD. بڕی کۆتایی IQD لە کاتی پارەدان بە نرخی ئاڵوگۆڕی ئێستا دەژمێردرێت.',
    'دوای پارەدانی سەرکەوتوو، eSIMـەکەت لە ئەپ دەگەیەنرێت. دامەزراندن پێویستی بە مۆبایلی گونجاو و کراوەی eSIM هەیە.',
    'گەڕاندنەوەی پارە بە حاڵەت جێبەجێ دەکرێت. ئەگەر دابینکردن سەرکەوتوو نەبوو، پارە دەگەڕێنینەوە. پەیوەندی بە پشتگیری بکە.',
    'ئێمە دەتوانین ئەم مەرجەکان نوێ بکەینەوە. بەردەوامبوون لە بەکارهێنان واتای قبوڵکردنی مەرجە نوێکانە.',
  ];

  static const _privacyEnBase = [
    'eSIM KRD respects your privacy. This policy explains what we collect and how we use it.',
    'Account data: when you sign in with Google or Apple we store your name, email, and a Firebase user identifier to manage your account and orders.',
    'Order data: we store package details, payment status, and eSIM identifiers (ICCID) needed to deliver and support your plan.',
    'Payments are processed by third-party providers (FIB, Stripe, etc.). We do not store full card numbers.',
    'We use your data to deliver eSIMs, provide support, prevent fraud, and improve the service. We do not sell your personal data.',
    'You may delete your account from the Profile screen. This removes your account data from our servers.',
  ];

  static const _privacyArBase = [
    'eSIM KRD يحترم خصوصيتك. يشرح هذا المستند ما نجمعه وكيف نستخدمه.',
    'بيانات الحساب: عند تسجيل الدخول عبر Google أو Apple نخزن الاسم والبريد ومعرّف Firebase لإدارة حسابك وطلباتك.',
    'بيانات الطلب: نخزن تفاصيل الباقة وحالة الدفع ومعرّفات eSIM (ICCID) لتسليم ودعم خطتك.',
    'تُعالَج المدفوعات عبر مزودين خارجيين. لا نخزن أرقام البطاقات الكاملة.',
    'نستخدم بياناتك لتسليم الشرائح والدعم ومنع الاحتيال وتحسين الخدمة. لا نبيع بياناتك الشخصية.',
    'يمكنك حذف حسابك من شاشة الملف الشخصي. هذا يزيل بياناتك من خوادمنا.',
  ];

  static const _privacyKuBase = [
    'eSIM KRD ڕێز لە تایبەتمەندی تۆ دەگرێت. ئەم دۆکیومێنتە ڕوون دەکاتەوە چی کۆدەکەینەوە و چۆن بەکاری دەهێنین.',
    'زانیاری هەژمار: کاتێک بە Google یان Apple دەچیتە ژوورەوە، ناو، ئیمەیڵ و ناسنامەی Firebase هەڵدەگرین.',
    'زانیاری داواکاری: وردەکاری پلان، دۆخی پارەدان و ICCID هەڵدەگرین بۆ گەیاندن و پشتگیری.',
    'پارەدان لە ڕێگەی دابینکەرانی دەرەکی (FIB، Stripe) دەکرێت. ژمارەی تەواوی کارت هەڵناگرین.',
    'زانیاری بەکاردەهێنین بۆ گەیاندنی eSIM، پشتگیری، ڕێگریکردن لە فێڵکردن و باشترکردنی خزمەتگوزاری.',
    'دەتوانیت هەژمار لە پرۆفایل بسڕیتەوە. ئەمە زانیاریەکانت لە سێرڤەرەکانمان دەسڕێتەوە.',
  ];

  static String _privacyContact(String languageCode, String email) {
    return switch (languageCode) {
      'ku' => 'بۆ پرسیاری تایبەتمەندی پەیوەندی بە $email بکە.',
      'ar' => 'لأسئلة الخصوصية تواصل مع $email.',
      _ => 'For privacy questions contact $email.',
    };
  }

  static const _faqEn = [
    'How do I install my eSIM? Open My eSIMs, tap your plan, and follow the iPhone or Android steps. QR scan or one-tap install is available.',
    'When does my plan start? Most plans activate when the eSIM connects to a supported network abroad.',
    'Payment pending? Open Profile → Order history and tap Complete payment to resume checkout.',
    'Need help with a charge? Email us with your order number and payment screenshot.',
  ];

  static const _faqAr = [
    'كيف أثبّت eSIM؟ افتح شرائحي، اضغط على الباقة واتبع خطوات iPhone أو Android.',
    'متى تبدأ الباقة؟ تُفعَّل عادة عند اتصال eSIM بشبكة مدعومة في الخارج.',
    'الدفع معلّق؟ افتح الملف الشخصي → سجل الطلبات واضغط إتمام الدفع.',
    'مساعدة في الدفع؟ راسلنا مع رقم الطلب ولقطة من الدفع.',
  ];

  static const _faqKu = [
    'چۆن eSIM دامەزرێنم؟ My eSIMs بکەرەوە، پلانەکە دابگرە و هەنگاوەکانی iPhone یان Android بەدوادا بکە.',
    'پلانەکە کەی دەست پێدەکات؟ زۆرجار کاتێک eSIM بە تۆڕی گونجاو لە دەرەوە دەبەستێت.',
    'پارەدان هێشتا ماوە؟ پرۆفایل → مێژووی داواکاری → تەواوکردنی پارەدان.',
    'یارمەتی لە پارەدان؟ ئیمەیڵ بکە لەگەڵ ژمارەی داواکاری و وێنەی پارەدان.',
  ];
}
