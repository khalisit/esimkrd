// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'eSIM KRD';

  @override
  String get heroTitlePart1 => 'سافر ';

  @override
  String get heroTitleHighlight => 'متصلاً';

  @override
  String get heroTitlePart2 => '، في أي مكان';

  @override
  String get heroSubtitle =>
      'باقات eSIM لأكثر من 200 دولة. توصيل فوري، بدون شريحة فعلية.';

  @override
  String destinationsCount(int count) {
    return '$count+ وجهة';
  }

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get browsePlans => 'تصفح الباقات';

  @override
  String get searchCountries => 'ابحث عن دولة...';

  @override
  String get kurdistanRegion => 'كردستان والمنطقة';

  @override
  String get kurdistanRegionSubtitle => 'باقات للعراق، تركيا، أوروبا والمزيد';

  @override
  String get popularDestinations => 'الوجهات الشائعة';

  @override
  String get allCountries => 'جميع الدول';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get loadingCountries => 'جاري تحميل الدول...';

  @override
  String get loadingPackages => 'جاري تحميل الباقات...';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get apiError => 'تعذر الاتصال بالخادم';

  @override
  String get retry => 'حاول مرة أخرى';

  @override
  String get loginRequired => 'يرجى تسجيل الدخول أولاً';

  @override
  String get orderCreated => 'تم إنشاء الطلب بنجاح ✅';

  @override
  String get openingPayment => 'جاري فتح صفحة الدفع...';

  @override
  String get paymentUrlMissing => 'لم يتم إرجاع رابط الدفع';

  @override
  String get paymentTitle => 'الدفع';

  @override
  String get paymentComplete => 'اكتمل الدفع — ستظهر شريحة eSIM قريباً';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get total => 'الإجمالي';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get totalIqd => 'الإجمالي (دينار)';

  @override
  String orderNumber(int id) {
    return 'طلب #$id';
  }

  @override
  String get paySecurely => 'ادفع بأمان';

  @override
  String get securePayment => 'دفع آمن';

  @override
  String get poweredByWayl => 'FIB · زين كاش · Visa';

  @override
  String get checkoutDisclaimer =>
      'سيتم تسليم شريحة eSIM فوراً بعد تأكيد الدفع.';

  @override
  String get loadingPayment => 'جاري تحميل صفحة الدفع الآمنة...';

  @override
  String get cancelPayment => 'إلغاء الدفع؟';

  @override
  String get cancelPaymentConfirm =>
      'تم حفظ طلبك. يمكنك إكمال الدفع لاحقاً من شرائحي.';

  @override
  String get stay => 'متابعة الدفع';

  @override
  String get leave => 'مغادرة';

  @override
  String get confirmingPayment => 'جاري تأكيد الدفع';

  @override
  String get confirmingPaymentSubtitle =>
      'يرجى الانتظار بينما نتحقق من معاملتك...';

  @override
  String get paymentSuccess => 'تم الدفع بنجاح!';

  @override
  String get paymentSuccessSubtitle =>
      'جاري تجهيز شريحة eSIM وستظهر في شرائحي قريباً.';

  @override
  String get paymentPending => 'الدفع قيد المعالجة';

  @override
  String get paymentPendingSubtitle =>
      'ما زلنا ننتظر التأكيد. تحقق من شرائحي بعد بضع دقائق.';

  @override
  String get paymentFailed => 'تعذر تأكيد الدفع';

  @override
  String get paymentFailedSubtitle =>
      'إذا تم خصم المبلغ، تواصل مع الدعم مع رقم الطلب.';

  @override
  String get viewMyEsims => 'عرض شرائحي';

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get paymentStepsTitle => 'كيف تدفع بـ Visa / البطاقة';

  @override
  String get paymentStep1 => 'أدخل رقم واتساب وأكد رمز التحقق';

  @override
  String get paymentStep2 => 'اضغط تبويب «Cards» (Visa / Mastercard)';

  @override
  String get paymentStep3 => 'أدخل رقم البطاقة والتاريخ و CVV';

  @override
  String get paymentStep4 => 'ستصلك eSIM فوراً بعد الدفع';

  @override
  String get paymentWaylNote =>
      'Wayl يطلب واتساب أولاً — ثم يظهر نموذج البطاقة.';

  @override
  String get continueToPay => 'متابعة الدفع';

  @override
  String get paymentSheetHint => 'آمن · FIB · زين كاش · Visa';

  @override
  String get fibPaymentTitle => 'الدفع عبر FIB';

  @override
  String get fibPaymentSubtitle => 'افتح FIB، أرسل المبلغ، ثم عد هنا.';

  @override
  String get fibAccountLabel => 'حساب FIB';

  @override
  String get fibPhoneLabel => 'رقم FIB';

  @override
  String get fibIbanLabel => 'IBAN';

  @override
  String get fibReferenceLabel => 'المرجع (اكتبه في الملاحظة)';

  @override
  String get fibPaymentNote =>
      'أرسل مبلغ IQD بالكامل إلى حساب FIB. يجب كتابة المرجع في ملاحظة التحويل.';

  @override
  String get fibOpenApp => 'فتح تطبيق FIB';

  @override
  String get fibOpenAppManually => 'افتح تطبيق FIB على هاتفك ثم أرسل الدفع.';

  @override
  String get fibMarkPaid => 'لقد دفعت';

  @override
  String get fibStepsTitle => 'كيف تدفع عبر FIB';

  @override
  String get fibStep1 => 'افتح تطبيق FIB على هاتفك';

  @override
  String get fibStep2 => 'أرسل مبلغ IQD المعروض بالكامل';

  @override
  String get fibStep3 => 'اكتب رمز المرجع في ملاحظة التحويل';

  @override
  String get fibStep4 => 'اضغط «لقد دفعت» — نتحقق ونسلم eSIM';

  @override
  String get fibSheetHint => 'تحويل FIB يدوي · يتم التحقق خلال ساعات';

  @override
  String get fibManualPendingTitle => 'تم إرسال الدفع';

  @override
  String get fibManualPendingSubtitle =>
      'استلمنا تأكيدك. بعد التحقق من تحويل FIB، ستظهر eSIM في «شرائحي».';

  @override
  String get paymentMethodTitle => 'طريقة الدفع';

  @override
  String get paymentMethodSubtitle => 'دفع آمن — Visa و Mastercard و Apple Pay';

  @override
  String get paymentMethodFib => 'الدفع عبر FIB';

  @override
  String get paymentMethodFibDesc => 'تحويل بنكي بالدينار العراقي';

  @override
  String get paymentMethodCard => 'الدفع بالبطاقة';

  @override
  String get paymentMethodCardDesc => 'Visa و Mastercard و Apple Pay';

  @override
  String get paymentBadgePopular => 'الأكثر استخداماً';

  @override
  String get paymentBadgeInstant => 'تسليم فوري';

  @override
  String get paymentBadgeLocal => 'العراق';

  @override
  String payAmount(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get securedByStripe => 'محمي بواسطة Stripe';

  @override
  String copiedToClipboard(String label) {
    return 'تم نسخ $label';
  }

  @override
  String get fibPayTitle => 'الدفع عبر FIB';

  @override
  String get fibScanTitle => 'امسح للدفع عبر FIB';

  @override
  String get fibScanSubtitle => 'افتح تطبيق FIB وامسح رمز QR هذا';

  @override
  String get fibReadableCode => 'رمز الدفع';

  @override
  String get fibOpenAppTitle => 'أو افتح تطبيق FIB مباشرة';

  @override
  String get fibPersonalApp => 'فتح FIB Personal';

  @override
  String get fibBusinessApp => 'فتح FIB Business';

  @override
  String get fibWaitingPayment => 'بانتظار الدفع… يتم التحديث تلقائيًا.';

  @override
  String get fibCheckStatus => 'لقد دفعت — تحقق الآن';

  @override
  String get fibAppNotInstalled =>
      'تعذّر فتح تطبيق FIB. يرجى مسح رمز QR بدلاً من ذلك.';

  @override
  String get fibTransferDetails => 'تفاصيل التحويل';

  @override
  String get cardCheckoutSubtitle => 'ستكمل الدفع على صفحة Stripe الآمنة';

  @override
  String get cardPaymentTitle => 'دفع آمن بالبطاقة';

  @override
  String get cardPaymentNote =>
      'أكمل الدفع عبر Stripe. يتم تسليم eSIM تلقائياً.';

  @override
  String get cardStepsTitle => 'كيف تدفع بالبطاقة';

  @override
  String get cardStep1 => 'أدخل بيانات البطاقة في الصفحة الآمنة';

  @override
  String get cardStep2 => 'أكمل الدفع — عبر Stripe';

  @override
  String get cardStep3 => 'ستصل eSIM فوراً في «شرائحي»';

  @override
  String get cardSheetHint => 'تشفير 256-bit · Stripe · Visa · Mastercard';

  @override
  String errorGeneric(String message) {
    return 'خطأ: $message';
  }

  @override
  String get noPackages => 'لا توجد باقات';

  @override
  String plansAvailable(int count) {
    return '$count باقة متاحة';
  }

  @override
  String get countryHeroDesc =>
      'اختر باقة البيانات. eSIM فوري عبر QR — بدون زيارة المتجر.';

  @override
  String daysCount(int count) {
    return '$count يوم';
  }

  @override
  String get buy => 'شراء';

  @override
  String get details => 'التفاصيل';

  @override
  String get less => 'أقل';

  @override
  String get packageDetails => 'توصيل eSIM فوري · QR code · بدون شريحة فعلية';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterLimited => 'محدود';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signInTo => 'تسجيل الدخول إلى ';

  @override
  String get join => 'انضم إلى ';

  @override
  String get name => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get register => 'تسجيل';

  @override
  String get login => 'دخول';

  @override
  String get continueWithGoogle => 'المتابعة مع Google';

  @override
  String get continueWithApple => 'المتابعة مع Apple';

  @override
  String get signInWithAccount => 'تسجيل الدخول بالحساب';

  @override
  String get emailPasswordDesc => 'البريد وكلمة المرور';

  @override
  String get createAccountHint => 'أدخل اسمك وبريدك وكلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'أدخل بريداً صالحاً';

  @override
  String get passwordMinLength => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get googleSignInDesc => 'نقرة واحدة · آمن';

  @override
  String get signInDisclaimer => 'تسجيل دخول آمن ومشفر';

  @override
  String get signInWithSocial => 'أو المتابعة مع Google أو Apple';

  @override
  String get haveAccount => 'لديك حساب؟ سجل الدخول';

  @override
  String get noAccount => 'إنشاء حساب جديد';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get canBuyNow => 'يمكنك الآن شراء eSIM';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف حسابك؟';

  @override
  String get deleteAccountMessage =>
      'سيؤدي هذا إلى حذف حسابك وطلباتك وبيانات eSIM نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteAccountConfirm => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get accountDeleted => 'تم حذف حسابك';

  @override
  String get splashTagline => 'سافر متصلاً، في أي مكان';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get kurdish => 'کوردی';

  @override
  String get navStore => 'المتجر';

  @override
  String get navMyEsims => 'شرائحي';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get myEsimsTitle => 'شرائح eSIM';

  @override
  String get myEsimsEmpty => 'لم تشتري أي eSIM بعد';

  @override
  String get myEsimsLogin => 'سجل الدخول لعرض شرائحك';

  @override
  String get myEsimsGoStore => 'تصفح المتجر';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileGuest => 'زائر';

  @override
  String get profileGuestHint => 'سجل الدخول لإدارة حسابك وشرائح eSIM';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusExpired => 'منتهي';

  @override
  String get statusDepleted => 'نفد';

  @override
  String dataUsage(String used, String total) {
    return 'البيانات: $used / $total';
  }

  @override
  String expiresOn(String date) {
    return 'ينتهي: $date';
  }

  @override
  String iccid(String value) {
    return 'ICCID: $value';
  }

  @override
  String get esimTapToInstall => 'اضغط للاستخدام والتثبيت';

  @override
  String get esimDetailTitle => 'تفاصيل eSIM';

  @override
  String get esimRefreshUsage => 'تحديث الاستخدام';

  @override
  String get esimUsageTitle => 'استخدام البيانات';

  @override
  String get esimUsageUnavailable =>
      'سيظهر الاستخدام بعد تفعيل الشريحة على الشبكة.';

  @override
  String esimUsageSummary(String used, String total) {
    return 'تم استخدام $used من $total';
  }

  @override
  String get esimUsed => 'المستخدم';

  @override
  String get esimRemaining => 'المتبقي';

  @override
  String get esimTotal => 'الإجمالي';

  @override
  String get esimDataLeft => 'متبقي';

  @override
  String get esimUnlimited => 'غير محدود';

  @override
  String get esimUnlimitedHint => 'هذه الباقة ببيانات غير محدودة.';

  @override
  String get esimStatusNotActive => 'غير مفعّلة بعد';

  @override
  String esimVoiceLeft(int remaining, int total) {
    return 'المكالمات: $remaining / $total دقيقة';
  }

  @override
  String esimSmsLeft(int remaining, int total) {
    return 'الرسائل: $remaining / $total';
  }

  @override
  String get esimTabIphone => 'iPhone';

  @override
  String get esimTabAndroid => 'Android';

  @override
  String get esimInstallTitle => 'تثبيت eSIM';

  @override
  String get esimInstallHowTitle => 'ثبّت شريحة eSIM';

  @override
  String get esimInstallHowSubtitle =>
      'اختر نوع هاتفك. تثبيت بضغطة على iPhone، أو امسح QR على Android.';

  @override
  String get esimScanQr => 'امسح رمز QR هذا';

  @override
  String get esimInstallOnIphone => 'التثبيت على iPhone';

  @override
  String get esimInstallOnIphoneHint =>
      'الأفضل على iOS 17.4+. يفتح إعداد eSIM من Apple.';

  @override
  String get esimManualTitle => 'الرموز اليدوية';

  @override
  String get esimManualSubtitle =>
      'اضغط للنسخ إذا لم يتوفر QR أو التثبيت السريع.';

  @override
  String get esimSmdpAddress => 'SM-DP+ Address';

  @override
  String get esimActivationCode => 'Activation Code';

  @override
  String get esimConfirmationCode => 'Confirmation Code';

  @override
  String get esimConfirmationOptional =>
      'Confirmation Code: اتركه فارغًا ما لم يزوّدك المشغّل برمز.';

  @override
  String get esimStepsIphoneTitle => 'خطوات iPhone';

  @override
  String get esimStepIphone1 => 'Settings → Cellular → Add eSIM';

  @override
  String get esimStepIphone2 => 'Use QR Code أو Enter Details Manually';

  @override
  String get esimStepIphone3 => 'أدخل SM-DP+ و Activation Code';

  @override
  String get esimStepIphone4 => 'فعّل Data Roaming عند الوصول';

  @override
  String get esimStepsAndroidTitle => 'خطوات Android';

  @override
  String get esimStepAndroid1 => 'Settings → Network & internet → SIMs';

  @override
  String get esimStepAndroid2 => 'Download a SIM / Add eSIM';

  @override
  String get esimStepAndroid3 => 'امسح رمز QR أعلاه';

  @override
  String get esimStepAndroid4 => 'فعّل Mobile data + Roaming لهذه الشريحة';

  @override
  String esimApnHint(String apn) {
    return 'إذا لزم الأمر، اضبط APN على: $apn';
  }

  @override
  String get esimRoamingHint =>
      'بعد التثبيت: فعّل Data Roaming واختر هذه الشريحة لبيانات الجوال.';

  @override
  String get esimOpenShareLink => 'فتح صفحة التثبيت';

  @override
  String esimShareCode(String code) {
    return 'رمز الدخول: $code';
  }

  @override
  String get esimOpenLinkFailed => 'تعذر فتح الرابط';

  @override
  String get orderHistoryTitle => 'سجل الطلبات';

  @override
  String get orderHistoryEmpty => 'لا توجد طلبات بعد';

  @override
  String get orderStatusPending => 'بانتظار الدفع';

  @override
  String get orderStatusPaid => 'جاري معالجة الدفع';

  @override
  String get orderStatusProcessing => 'تجهيز eSIM';

  @override
  String get orderStatusCompleted => 'مكتمل';

  @override
  String get orderStatusFailed => 'فشل';

  @override
  String get completePayment => 'إتمام الدفع';

  @override
  String get orderAwaitingVerification => 'بانتظار التحقق';

  @override
  String get termsTitle => 'شروط الخدمة';

  @override
  String get privacyTitle => 'سياسة الخصوصية';

  @override
  String get supportTitle => 'المساعدة والدعم';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get contactEmail => 'راسلنا بالبريد';

  @override
  String get contactWhatsapp => 'واتساب';

  @override
  String get supportContactTitle => 'تواصل معنا';

  @override
  String get supportFaqTitle => 'أسئلة شائعة';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingSlide1Title => 'ابقَ متصلاً في أي مكان';

  @override
  String get onboardingSlide1Body =>
      'تصفح باقات eSIM لأكثر من 200 دولة. تسليم فوري — بدون شريحة فعلية.';

  @override
  String get onboardingSlide2Title => 'التثبيت في دقائق';

  @override
  String get onboardingSlide2Body =>
      'امسح QR على Android أو ثبّت بضغطة على iPhone. تُفعَّل الباقة عند الاتصال بالشبكة.';

  @override
  String get onboardingSlide3Title => 'ادفع بأمان';

  @override
  String get onboardingSlide3Body =>
      'ادفع عبر FIB بالدينار أو بالبطاقة عبر Stripe. تظهر الشريحة في شرائحي بعد الدفع.';

  @override
  String get offlineTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get offlineMessage => 'تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get esimLowDataTitle => 'البيانات على وشك النفاد';

  @override
  String esimLowDataMessage(int percent) {
    return 'تبقى $percent% فقط من البيانات. فكّر في تجديد الباقة قبل النفاد.';
  }

  @override
  String get esimExpirySoonTitle => 'الباقة تنتهي قريباً';

  @override
  String esimExpirySoonMessage(int days) {
    return 'تنتهي باقتك خلال $days أيام. جدّد قبل سفرك القادم.';
  }

  @override
  String get shareReceipt => 'مشاركة الإيصال';

  @override
  String get receiptTitle => 'إيصال eSIM KRD';

  @override
  String get promoCodeLabel => 'رمز ترويجي';

  @override
  String get promoCodeHint => 'أدخل الرمز';

  @override
  String get promoApply => 'تطبيق';

  @override
  String get promoDiscount => 'خصم';

  @override
  String get topUpTitle => 'إضافة بيانات';

  @override
  String get topUpSubtitle => 'جدّد أو أضف بيانات لهذه الشريحة.';

  @override
  String get topUpAction => 'تجديد / إضافة';

  @override
  String get referralTitle => 'ادعُ أصدقاءك';

  @override
  String get referralSubtitle => 'شارك رمزك وادعُ أصدقاءك إلى eSIM KRD.';

  @override
  String get referralShare => 'مشاركة رابط الدعوة';

  @override
  String referralShareMessage(String code) {
    return 'احصل على eSIM مع eSIM KRD! استخدم رمزي: $code';
  }

  @override
  String referralCount(int count) {
    return 'انضم $count صديق';
  }

  @override
  String get currencyDisplay => 'عرض العملة';

  @override
  String get currencyBoth => 'USD + IQD';

  @override
  String get currencyUsd => 'USD فقط';

  @override
  String get currencyIqd => 'IQD فقط';
}
