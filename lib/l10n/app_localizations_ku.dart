// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kurdish (`ku`).
class AppLocalizationsKu extends AppLocalizations {
  AppLocalizationsKu([String locale = 'ku']) : super(locale);

  @override
  String get appTitle => 'eSIM KRD';

  @override
  String get heroTitlePart1 => 'گەشت بکە ';

  @override
  String get heroTitleHighlight => 'پەیوەندیدار';

  @override
  String get heroTitlePart2 => '، لە هەر شوێنێک';

  @override
  String get heroSubtitle =>
      'پاکێجی eSIM بۆ ٢٠٠+ وڵات. گەیاندنی خێرا، بێ SIM فیزیکی.';

  @override
  String destinationsCount(int count) {
    return '$count+ شوێن';
  }

  @override
  String get getStarted => 'دەست پێبکە';

  @override
  String get browsePlans => 'پلانەکان ببینە';

  @override
  String get searchCountries => 'گەڕان بۆ وڵات...';

  @override
  String get kurdistanRegion => 'کوردستان و دەوروبەر';

  @override
  String get kurdistanRegionSubtitle =>
      'پلان بۆ عێراق، تورکیا، ئەوروپا و زیاتر';

  @override
  String get popularDestinations => 'شوێنە بەناوبانگەکان';

  @override
  String get allCountries => 'هەموو وڵاتەکان';

  @override
  String get noResults => 'هیچ ئەنجامێک نەدۆزرایەوە';

  @override
  String get loadingCountries => 'وڵاتەکان بار دەکرێن...';

  @override
  String get loadingPackages => 'پاکێجەکان بار دەکرێن...';

  @override
  String get loading => 'بارکردن...';

  @override
  String get apiError => 'ناتوانرێت API بگات';

  @override
  String get retry => 'دووبارە هەوڵبدەرەوە';

  @override
  String get loginRequired => 'تکایە سەرەتا چوونەژوورەوە بکە';

  @override
  String get orderCreated => 'داواکاری دروستکرا ✅';

  @override
  String get openingPayment => 'کردنەوەی پەڕەی پارەدان...';

  @override
  String get paymentUrlMissing => 'بەستەری پارەدان نەگەڕایەوە';

  @override
  String get paymentTitle => 'پارەدان';

  @override
  String get paymentComplete =>
      'پارەدان تەواوبوو — eSIMـەکەت بەم زووانە دەردەکەوێت';

  @override
  String get checkoutTitle => 'کڕین';

  @override
  String get orderSummary => 'پوختەی داواکاری';

  @override
  String get total => 'کۆی گشتی';

  @override
  String get subtotal => 'کۆی گشتی';

  @override
  String get totalIqd => 'کۆی گشتی (دینار)';

  @override
  String orderNumber(int id) {
    return 'داواکاری #$id';
  }

  @override
  String get paySecurely => 'پارەدانی پارێزراو';

  @override
  String get securePayment => 'پارەدانی پارێزراو';

  @override
  String get poweredByWayl => 'FIB · زینکاش · Visa';

  @override
  String get checkoutDisclaimer =>
      'eSIMـەکەت دەستبەجێ دوای دڵنیاکردنەوەی پارەدان دەگەیەنرێت.';

  @override
  String get loadingPayment => 'کردنەوەی پارەدانی پارێزراو...';

  @override
  String get cancelPayment => 'هەڵوەشاندنەوەی پارەدان؟';

  @override
  String get cancelPaymentConfirm =>
      'داواکارییەکەت پاشەکەوت کراوە. دەتوانیت دواتر پارەدان تەواو بکەیت.';

  @override
  String get stay => 'بەردەوامبوون لە پارەدان';

  @override
  String get leave => 'دەرچوون';

  @override
  String get confirmingPayment => 'دڵنیاکردنەوەی پارەدان';

  @override
  String get confirmingPaymentSubtitle =>
      'تکایە چاوەڕێ بکە تا مامەڵەکەت پشتڕاست دەکرێتەوە...';

  @override
  String get paymentSuccess => 'پارەدان سەرکەوتوو بوو!';

  @override
  String get paymentSuccessSubtitle =>
      'eSIMـەکەت ئامادە دەکرێت و بەم زووانە لە eSIMـەکانمدا دەردەکەوێت.';

  @override
  String get paymentPending => 'پارەدان لە جێبەجێکردندایە';

  @override
  String get paymentPendingSubtitle =>
      'هێشتا چاوەڕوانی دڵنیاکردنەوەین. چەند خولەکێک دواتر سەیری eSIMـەکانم بکە.';

  @override
  String get paymentFailed => 'نەتوانرا پارەدان دڵنیا بکرێتەوە';

  @override
  String get paymentFailedSubtitle =>
      'ئەگەر پارە دراوە، پەیوەندی بە پشتگیریەوە بکە لەگەڵ ژمارەی داواکاری.';

  @override
  String get viewMyEsims => 'بینینی eSIMـەکانم';

  @override
  String get continueShopping => 'بەردەوامبوون لە کڕین';

  @override
  String get paymentStepsTitle => 'چۆن بە Visa / کارت پارە بدەیت';

  @override
  String get paymentStep1 => 'ژمارەی واتسئاپ + کۆدی پشتڕاستکردنەوە';

  @override
  String get paymentStep2 => 'تابی «Cards» هەڵبژێرە (Visa / Mastercard)';

  @override
  String get paymentStep3 => 'ژمارەی کارت، بەروار و CVV بنووسە';

  @override
  String get paymentStep4 => 'eSIMـەکەت دەستبەجێ دوای پارەدان دەگات';

  @override
  String get paymentWaylNote =>
      'Wayl پێشتر واتسئاپ دەوێت — دواتر فۆڕمی کارت دەردەکەوێت.';

  @override
  String get continueToPay => 'بەردەوامبوون بۆ پارەدان';

  @override
  String get paymentSheetHint => 'پارێزراو · FIB · زینکاش · Visa';

  @override
  String get fibPaymentTitle => 'پارەدان بە FIB';

  @override
  String get fibPaymentSubtitle => 'FIB بکەرەوە، پارە بنێرە، دواتر بگەڕێرەوە.';

  @override
  String get fibAccountLabel => 'هەژماری FIB';

  @override
  String get fibPhoneLabel => 'ژمارەی FIB';

  @override
  String get fibIbanLabel => 'IBAN';

  @override
  String get fibReferenceLabel => 'کۆدی سەرچاوە (لە تێبینی بنووسە)';

  @override
  String get fibPaymentNote =>
      'بڕی IQD بە تەواوی بنێرە بۆ هەژماری FIB. کۆدی سەرچاوە لە تێبینی بنووسە.';

  @override
  String get fibOpenApp => 'کردنەوەی ئەپی FIB';

  @override
  String get fibOpenAppManually =>
      'ئەپی FIB لە مۆبایلەکەت بکەرەوە و پارە بنێرە.';

  @override
  String get fibMarkPaid => 'پارەم نارد';

  @override
  String get fibStepsTitle => 'چۆن بە FIB پارە بدەیت';

  @override
  String get fibStep1 => 'ئەپی FIB لە مۆبایلەکەت بکەرەوە';

  @override
  String get fibStep2 => 'بڕی IQD بە تەواوی بنێرە';

  @override
  String get fibStep3 => 'کۆدی سەرچاوە لە تێبینی بنووسە';

  @override
  String get fibStep4 => '«پارەم نارد» بگرە — دڵنیا دەکەینەوە و eSIM دەگەیەنین';

  @override
  String get fibSheetHint => 'گواستنەوەی دەستی FIB · لە ماوەی چەند کاتژمێردا';

  @override
  String get fibManualPendingTitle => 'پارەدان نێردرا';

  @override
  String get fibManualPendingSubtitle =>
      'دڵنیاکردنەوەکەت وەرگرت. دوای پشتڕاستکردنەوەی گواستنەوەی FIB، eSIM لە «eSIMـەکانم» دەردەکەوێت.';

  @override
  String get paymentMethodTitle => 'شێوازی پارەدان';

  @override
  String get paymentMethodSubtitle =>
      'پارەدانی پارێزراو — Visa، Mastercard و Apple Pay';

  @override
  String get paymentMethodFib => 'پارەدان بە FIB';

  @override
  String get paymentMethodFibDesc => 'گواستنەوەی بانکی بە دیناری عێراقی';

  @override
  String get paymentMethodCard => 'پارەدان بە کارت';

  @override
  String get paymentMethodCardDesc => 'Visa، Mastercard و Apple Pay';

  @override
  String get paymentMethodRasedi => 'پارەدانی پارێزراو';

  @override
  String get paymentMethodRasediDesc =>
      'FIB، ZainCash، FastPay، Nass، AsiaPay و کارت';

  @override
  String get paymentBadgePopular => 'بەناوبانگ';

  @override
  String get paymentBadgeInstant => 'گەیاندنی خێرا';

  @override
  String get paymentBadgeLocal => 'عێراق';

  @override
  String payAmount(String amount) {
    return 'پارەدان $amount';
  }

  @override
  String get securedByStripe => 'پارەدانی پارێزراو';

  @override
  String copiedToClipboard(String label) {
    return '$label کۆپی کرا';
  }

  @override
  String get fibPayTitle => 'پارەدان بە FIB';

  @override
  String get fibScanTitle => 'بۆ پارەدان بە FIB سکان بکە';

  @override
  String get fibScanSubtitle => 'ئەپی FIB بکەرەوە و ئەم کۆدە QRـە سکان بکە';

  @override
  String get fibReadableCode => 'کۆدی پارەدان';

  @override
  String get fibOpenAppTitle => 'یان ڕاستەوخۆ ئەپی FIB بکەرەوە';

  @override
  String get fibPersonalApp => 'کردنەوەی FIB Personal';

  @override
  String get fibBusinessApp => 'کردنەوەی FIB Business';

  @override
  String get fibWaitingPayment =>
      'چاوەڕوانی پارەدانەکەتین… خۆکارانە نوێ دەبێتەوە.';

  @override
  String get fibCheckStatus => 'پارەم دا — ئێستا بپشکنە';

  @override
  String get fibAppNotInstalled =>
      'نەتوانرا ئەپی FIB بکرێتەوە. تکایە لەجیاتی ئەوە کۆدی QR سکان بکە.';

  @override
  String get fibTransferDetails => 'وردەکاری گواستنەوە';

  @override
  String get cardCheckoutSubtitle =>
      'پارەدان لەسەر پەڕەی پارێزراوی Stripe تەواو دەکەیت';

  @override
  String get cardPaymentTitle => 'پارەدانی ئاسایشی کارت';

  @override
  String get cardPaymentNote =>
      'پارەدان لەسەر Stripe تەواو بکە. eSIM خۆکار دەگات.';

  @override
  String get cardStepsTitle => 'چۆن بە کارت پارە بدەیت';

  @override
  String get cardStep1 => 'وردەکاری کارت لە پەڕەی ئاسایش بنووسە';

  @override
  String get cardStep2 => 'پارەدان تەواو بکە — Stripe';

  @override
  String get cardStep3 => 'eSIM دەستبەجێ لە «eSIMـەکانم» دەردەکەوێت';

  @override
  String get cardSheetHint => 'شێوەزاری 256-bit · Stripe · Visa · Mastercard';

  @override
  String errorGeneric(String message) {
    return 'هەڵە: $message';
  }

  @override
  String get noPackages => 'هیچ پاکێجێک نییە';

  @override
  String plansAvailable(int count) {
    return '$count پلان بەردەستە';
  }

  @override
  String get countryHeroDesc =>
      'پلانی داتا هەڵبژێرە. eSIM بە QR — بێ سەردانی فرۆشگا.';

  @override
  String daysCount(int count) {
    return '$count ڕۆژ';
  }

  @override
  String get buy => 'کڕین';

  @override
  String get details => 'وردەکاری';

  @override
  String get less => 'کەمتر';

  @override
  String get packageDetails => 'گەیاندنی eSIM · QR code · بێ SIM فیزیکی';

  @override
  String get unlimited => 'بێسنوور';

  @override
  String get filterAll => 'هەموو';

  @override
  String get filterLimited => 'سنووردار';

  @override
  String get welcomeBack => 'بەخێربێیتەوە';

  @override
  String get createAccount => 'هەژمار دروستکردن';

  @override
  String get signInTo => 'چوونەژوورەوە بۆ ';

  @override
  String get join => 'بەشداری ';

  @override
  String get name => 'ناو';

  @override
  String get email => 'ئیمەیڵ';

  @override
  String get password => 'وشەی نهێنی';

  @override
  String get register => 'تۆمارکردن';

  @override
  String get login => 'چوونەژوورەوە';

  @override
  String get continueWithGoogle => 'بەردەوامبوون بە Google';

  @override
  String get continueWithApple => 'بەردەوامبوون بە Apple';

  @override
  String get signInWithAccount => 'چوونەژوورەوە بە هەژمار';

  @override
  String get emailPasswordDesc => 'ئیمەیڵ و وشەی نهێنی';

  @override
  String get createAccountHint => 'ناو، ئیمەیڵ و وشەی نهێنی بنووسە';

  @override
  String get confirmPassword => 'دووبارەکردنەوەی وشەی نهێنی';

  @override
  String get fieldRequired => 'ئەم خانەیە پێویستە';

  @override
  String get invalidEmail => 'ئیمەیڵێکی دروست بنووسە';

  @override
  String get passwordMinLength => 'وشەی نهێنی لانیکەم ٨ پیت بێت';

  @override
  String get passwordMismatch => 'وشە نهێنییەکان یەک ناگرنەوە';

  @override
  String get googleSignInDesc => 'تەنها یەک کلیک · پارێزراو';

  @override
  String get signInDisclaimer => 'چوونەژوورەوە بە پارێزراوی پارێزراوە';

  @override
  String get signInWithSocial => 'یان بەردەوامبە لەگەڵ Google یان Apple';

  @override
  String get haveAccount => 'هەژمارت هەیە؟ چوونەژوورەوە';

  @override
  String get noAccount => 'هەژمارێکی نوێ دروست بکە';

  @override
  String get loginSuccess => 'چوونەژوورەوە سەرکەوت';

  @override
  String get canBuyNow => 'ئێستا دەتوانیت eSIM بکڕیت';

  @override
  String get logout => 'چوونەدەرەوە';

  @override
  String get deleteAccount => 'سڕینەوەی هەژمار';

  @override
  String get deleteAccountTitle => 'هەژمارەکەت بسڕیتەوە؟';

  @override
  String get deleteAccountMessage =>
      'هەژمار، داواکاری و eSIMـەکانت بە تەواوی دەسڕێنەوە. ئەم کارە ناگەڕێتەوە.';

  @override
  String get deleteAccountConfirm => 'سڕینەوە';

  @override
  String get cancel => 'پاشگەزبوونەوە';

  @override
  String get accountDeleted => 'هەژمارەکەت سڕایەوە';

  @override
  String get splashTagline => 'گەشت بکە پەیوەندیدار، لە هەر شوێنێک';

  @override
  String get language => 'زمان';

  @override
  String get english => 'English';

  @override
  String get arabic => 'عەرەبی';

  @override
  String get kurdish => 'کوردی';

  @override
  String get navStore => 'فرۆشگا';

  @override
  String get navMyEsims => 'eSIMـەکانم';

  @override
  String get navProfile => 'هەژمار';

  @override
  String get myEsimsTitle => 'eSIMـەکانم';

  @override
  String get myEsimsEmpty => 'هێشتا هیچ eSIMـێکت نەکڕیوە';

  @override
  String get myEsimsLogin => 'چوونەژوورەوە بکە بۆ بینینی eSIMـەکانت';

  @override
  String get myEsimsGoStore => 'بڕۆ بۆ فرۆشگا';

  @override
  String get profileTitle => 'هەژمار';

  @override
  String get profileGuest => 'میوان';

  @override
  String get profileGuestHint =>
      'چوونەژوورەوە بکە بۆ بەڕێوەبردنی هەژمار و eSIM';

  @override
  String get statusActive => 'چالاک';

  @override
  String get statusExpired => 'بەسەرچوو';

  @override
  String get statusDepleted => 'تەواوبوو';

  @override
  String dataUsage(String used, String total) {
    return 'داتا: $used / $total';
  }

  @override
  String expiresOn(String date) {
    return 'بەسەردەچێت: $date';
  }

  @override
  String iccid(String value) {
    return 'ICCID: $value';
  }

  @override
  String get esimTapToInstall => 'کلیک بکە بۆ بەکارهێنان و دامەزراندن';

  @override
  String get esimDetailTitle => 'وردەکاری eSIM';

  @override
  String get esimRefreshUsage => 'نوێکردنەوەی بەکارهێنان';

  @override
  String get esimUsageTitle => 'بەکارهێنانی داتا';

  @override
  String get esimUsageUnavailable =>
      'دوای چالاکبوونی eSIM لە تۆڕ، بەکارهێنان دەردەکەوێت.';

  @override
  String esimUsageSummary(String used, String total) {
    return '$used لە $total بەکار هاتووە';
  }

  @override
  String get esimUsed => 'بەکارهاتوو';

  @override
  String get esimRemaining => 'ماوە';

  @override
  String get esimTotal => 'کۆی گشتی';

  @override
  String get esimDataLeft => 'ماوە';

  @override
  String get esimUnlimited => 'بێسنوور';

  @override
  String get esimUnlimitedHint => 'ئەم پلانە داتای بێسنووری هەیە.';

  @override
  String get esimStatusNotActive => 'هێشتا چالاک نەکراوە';

  @override
  String esimVoiceLeft(int remaining, int total) {
    return 'دەنگ: $remaining / $total خولەک';
  }

  @override
  String esimSmsLeft(int remaining, int total) {
    return 'SMS: $remaining / $total';
  }

  @override
  String get esimTabIphone => 'iPhone';

  @override
  String get esimTabAndroid => 'Android';

  @override
  String get esimInstallTitle => 'دامەزراندنی eSIM';

  @override
  String get esimInstallHowTitle => 'eSIMـەکەت دابمەزرێنە';

  @override
  String get esimInstallHowSubtitle =>
      'جۆری مۆبایلەکەت هەڵبژێرە. لە iPhone یەک کلیک، لە Android QR سکان بکە.';

  @override
  String get esimScanQr => 'ئەم کۆدی QR سکان بکە';

  @override
  String get esimInstallOnIphone => 'دامەزراندن لەسەر iPhone';

  @override
  String get esimInstallOnIphoneHint =>
      'باشترینە لەسەر iOS 17.4+. ڕێکخستنی eSIMـی ئەپڵ دەکاتەوە.';

  @override
  String get esimManualTitle => 'کۆدەکانی دەستی';

  @override
  String get esimManualSubtitle =>
      'کلیک بکە بۆ کۆپی. ئەگەر QR یان یەک کلیک نەبوو.';

  @override
  String get esimSmdpAddress => 'SM-DP+ Address';

  @override
  String get esimActivationCode => 'Activation Code';

  @override
  String get esimConfirmationCode => 'Confirmation Code';

  @override
  String get esimConfirmationOptional =>
      'Confirmation Code: بەتاڵی بهێڵە مەگەر کۆمپانیا کۆدی پێدابیت.';

  @override
  String get esimStepsIphoneTitle => 'هەنگاوەکانی iPhone';

  @override
  String get esimStepIphone1 => 'Settings → Cellular → Add eSIM';

  @override
  String get esimStepIphone2 => 'Use QR Code، یان Enter Details Manually';

  @override
  String get esimStepIphone3 => 'SM-DP+ و Activation Code بنووسە';

  @override
  String get esimStepIphone4 => 'کاتێک دەگەیتە وڵات، Data Roaming بکەرەوە';

  @override
  String get esimStepsAndroidTitle => 'هەنگاوەکانی Android';

  @override
  String get esimStepAndroid1 => 'Settings → Network & internet → SIMs';

  @override
  String get esimStepAndroid2 => 'Download a SIM / Add eSIM';

  @override
  String get esimStepAndroid3 => 'کۆدی QRـی سەرەوە سکان بکە';

  @override
  String get esimStepAndroid4 =>
      'Mobile data + Roaming بۆ ئەم eSIMـە چالاک بکە';

  @override
  String esimApnHint(String apn) {
    return 'ئەگەر پێویست بوو، APN دابنێ بۆ: $apn';
  }

  @override
  String get esimRoamingHint =>
      'دوای دامەزراندن: Data Roaming بکەرەوە و ئەم eSIMـە بۆ Mobile Data هەڵبژێرە.';

  @override
  String get esimOpenShareLink => 'کردنەوەی پەڕەی دامەزراندن';

  @override
  String esimShareCode(String code) {
    return 'کۆدی دەستگەیشتن: $code';
  }

  @override
  String get esimOpenLinkFailed => 'نەتوانرا لینکەکە بکرێتەوە';

  @override
  String get orderHistoryTitle => 'مێژووی داواکاری';

  @override
  String get orderHistoryEmpty => 'هێشتا داواکاری نییە';

  @override
  String get orderStatusPending => 'پارەدان ماوە';

  @override
  String get orderStatusPaid => 'پارەدان لە جێبەجێکردن';

  @override
  String get orderStatusProcessing => 'ئامادەکردنی eSIM';

  @override
  String get orderStatusCompleted => 'تەواو بوو';

  @override
  String get orderStatusFailed => 'سەرنەکەوت';

  @override
  String get completePayment => 'تەواوکردنی پارەدان';

  @override
  String get orderAwaitingVerification => 'چاوەڕوانی پشتڕاستکردنەوە';

  @override
  String get termsTitle => 'مەرجەکانی خزمەتگوزاری';

  @override
  String get privacyTitle => 'تایبەتمەندی';

  @override
  String get supportTitle => 'یارمەتی و پشتگیری';

  @override
  String get termsOfService => 'مەرجەکانی خزمەتگوزاری';

  @override
  String get privacyPolicy => 'تایبەتمەندی';

  @override
  String get helpSupport => 'یارمەتی و پشتگیری';

  @override
  String get contactEmail => 'ئیمەیڵ بنێرە';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get supportContactTitle => 'پەیوەندیمان پێوە بکە';

  @override
  String get supportFaqTitle => 'پرسیارە باوەکان';

  @override
  String get onboardingSkip => 'فەوتاندن';

  @override
  String get onboardingNext => 'دواتر';

  @override
  String get onboardingGetStarted => 'دەست پێ بکە';

  @override
  String get onboardingSlide1Title => 'لە هەر شوێنێک بەستراوە بمێنەرەوە';

  @override
  String get onboardingSlide1Body =>
      'پلانی داتای eSIM بۆ 200+ وڵات. گەیاندنی خێرا — پێویستی بە SIM فیزیکی نییە.';

  @override
  String get onboardingSlide2Title => 'دامەزراندن لە چەند خولەکدا';

  @override
  String get onboardingSlide2Body =>
      'QR سکان بکە لە Android یان یەک کلیک لە iPhone. پلانەکە کاتێک لە دەرەوە دەبەستێت چالاک دەبێت.';

  @override
  String get onboardingSlide3Title => 'پارەدان بە ئاسایی';

  @override
  String get onboardingSlide3Body =>
      'بە FIB بە دینار یان بە کارت لە Stripe پارە بدە. eSIM لە My eSIMs دەردەکەوێت.';

  @override
  String get offlineTitle => 'ئینتەرنێت نییە';

  @override
  String get offlineMessage =>
      'پەیوەندی ئینتەرنێتەکەت پشکنین بکە و دووبارە هەوڵ بدەرەوە.';

  @override
  String get sessionExpired =>
      'کاتی چوونەژوورەوەت تەواو بوو. دووبارە چوونەژوورەوە بکە.';

  @override
  String get esimLowDataTitle => 'داتا کەم ماوە';

  @override
  String esimLowDataMessage(int percent) {
    return 'تەنها $percent% داتا ماوە. پێش تەواوبوون پلانی زیاد بکە.';
  }

  @override
  String get esimExpirySoonTitle => 'پلان بەزووی بەسەردەچێت';

  @override
  String esimExpirySoonMessage(int days) {
    return 'پلانەکەت لە $days ڕۆژدا بەسەردەچێت. پێش گەشت دووبارە نوێی بکەرەوە.';
  }

  @override
  String get shareReceipt => 'هاوبەشکردنی وەسڵ';

  @override
  String get receiptTitle => 'وەسڵی eSIM KRD';

  @override
  String get promoCodeLabel => 'کۆدی پرۆمۆ';

  @override
  String get promoCodeHint => 'کۆد بنووسە';

  @override
  String get promoApply => 'جێبەجێکردن';

  @override
  String get promoDiscount => 'داشکاندن';

  @override
  String get topUpTitle => 'زیادکردنی داتا';

  @override
  String get topUpSubtitle => 'ئەم eSIMـە نوێ بکەرەوە یان داتای زیاد بکە.';

  @override
  String get topUpAction => 'Top up / نوێکردنەوە';

  @override
  String get referralTitle => 'هاوڕێ بنێرە';

  @override
  String get referralSubtitle =>
      'کۆدەکەت هاوبەش بکە و هاوڕێیەکانت بانگهێشت بکە.';

  @override
  String get referralShare => 'هاوبەشکردنی لینک';

  @override
  String referralShareMessage(String code) {
    return 'eSIM بگەرە لەگەڵ eSIM KRD! کۆدم بەکاربهێنە: $code';
  }

  @override
  String referralCount(int count) {
    return '$count هاوڕێ بەشداری کرد';
  }

  @override
  String get currencyDisplay => 'پیشاندانی دراو';

  @override
  String get currencyBoth => 'USD + IQD';

  @override
  String get currencyUsd => 'تەنها USD';

  @override
  String get currencyIqd => 'تەنها IQD';
}
