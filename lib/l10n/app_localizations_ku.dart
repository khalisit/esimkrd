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
  String get heroTitlePart1 => 'لە هەر کوێیەک بیت ';

  @override
  String get heroTitleHighlight => 'بە ئینتەرنێتەوە';

  @override
  String get heroTitlePart2 => ' بەستراوەبە';

  @override
  String get heroSubtitle =>
      'پاکێجی eSIM بۆ زیاتر لە ٢٠٠ وڵات. گەیاندنی دەستبەجێ، بێ پێویستی بە سیمکارتی فیزیکی.';

  @override
  String destinationsCount(int count) {
    return 'زیاتر لە $count وڵات';
  }

  @override
  String get getStarted => 'دەستپێبکە';

  @override
  String get browsePlans => 'پاکێجەکان ببینە';

  @override
  String get searchCountries => 'بگەڕێ بۆ وڵاتێک...';

  @override
  String get kurdistanRegion => 'کوردستان و دەوروبەر';

  @override
  String get kurdistanRegionSubtitle =>
      'پاکێجەکانی عێراق، تورکیا، ئەوروپا و زیاتر';

  @override
  String get popularDestinations => 'وڵاتە داواکراوەکان';

  @override
  String get allCountries => 'هەموو وڵاتەکان';

  @override
  String get noResults => 'هیچ ئەنجامێک نەدۆزرایەوە';

  @override
  String get loadingCountries => 'لە بارکردندایە...';

  @override
  String get loadingPackages => 'پاکێجەکان باردەکرێن...';

  @override
  String get loading => 'چاوەڕێبە...';

  @override
  String get apiError => 'کێشە لە پەیوەندیکردندایە';

  @override
  String get retry => 'دووبارە هەوڵبدەرەوە';

  @override
  String get loginRequired => 'تکایە سەرەتا بچۆ ژوورەوە';

  @override
  String get orderCreated => 'داواکارییەکەت سەرکەوتوو بوو ✅';

  @override
  String get openingPayment => 'چوون بۆ پەڕەی پارەدان...';

  @override
  String get paymentUrlMissing => 'بەستەری پارەدان نەدۆزرایەوە';

  @override
  String get paymentTitle => 'پارەدان';

  @override
  String get paymentComplete =>
      'پارەدانەکە سەرکەوتوو بوو — eSIM-ەکەت بەم زووانە بەردەست دەبێت.';

  @override
  String get checkoutTitle => 'کڕین';

  @override
  String get orderSummary => 'پوختەی داواکارییەکە';

  @override
  String get total => 'کۆی گشتی';

  @override
  String get subtotal => 'نرخ';

  @override
  String get totalIqd => 'کۆی گشتی (بە دینار)';

  @override
  String orderNumber(int id) {
    return 'داواکاری ژمارە $id';
  }

  @override
  String get paySecurely => 'پارەدانی پارێزراو';

  @override
  String get securePayment => 'پارەدانی پارێزراو';

  @override
  String get poweredByWayl => 'FIB · زینکاش · Visa';

  @override
  String get checkoutDisclaimer =>
      'eSIM-ەکەت دەستبەجێ دوای پشتڕاستکردنەوەی پارەدانەکە بەردەست دەبێت.';

  @override
  String get loadingPayment => 'کردنەوەی پەڕەی پارەدانی پارێزراو...';

  @override
  String get cancelPayment => 'پارەدانەکە هەڵدەوەشێنیتەوە؟';

  @override
  String get cancelPaymentConfirm =>
      'داواکارییەکەت پاشەکەوت کراوە. دەتوانیت دواتر پارەدانەکە تەواو بکەیت.';

  @override
  String get stay => 'بەردەوامبوون';

  @override
  String get leave => 'دەرچوون';

  @override
  String get confirmingPayment => 'پشتڕاستکردنەوەی پارەدان';

  @override
  String get confirmingPaymentSubtitle =>
      'تکایە چاوەڕێ بە تاوەکو مامەڵەکەت پشتڕاست دەکرێتەوە...';

  @override
  String get paymentSuccess => 'پارەدانەکە سەرکەوتوو بوو!';

  @override
  String get paymentSuccessSubtitle =>
      'eSIM-ەکەت ئامادە دەکرێت و بەم زووانە لە بەشی \'eSIM-ەکانم\' دەردەکەوێت.';

  @override
  String get paymentPending => 'پارەدانەکە لە جێبەجێکردندایە';

  @override
  String get paymentPendingSubtitle =>
      'هێشتا چاوەڕوانی پشتڕاستکردنەوەین. تکایە دوای چەند خولەکێکی تر سەیری بەشی \'eSIM-ەکانم\' بکە.';

  @override
  String get paymentFailed => 'پارەدانەکە پشتڕاست نەکراوەتەوە';

  @override
  String get paymentFailedSubtitle =>
      'ئەگەر پارەکەت لێ بڕاوە، تکایە پەیوەندی بە تیمی پشتگیرییەوە بکە و ژمارەی داواکارییەکەت پێبدە.';

  @override
  String get viewMyEsims => 'eSIM-ەکانم ببینە';

  @override
  String get continueShopping => 'بەردەوامبوون لە کڕین';

  @override
  String get paymentStepsTitle => 'چۆنیەتی پارەدان بە کارتی بانکی';

  @override
  String get paymentStep1 => 'ژمارەی واتسئاپ بنووسە لەگەڵ کۆدی پشتڕاستکردنەوە';

  @override
  String get paymentStep2 => 'لە بەشی پارەدان تابی «Cards» هەڵبژێرە';

  @override
  String get paymentStep3 =>
      'زانیارییەکانی کارتەکەت بنووسە (ژمارە، بەروار و CVV)';

  @override
  String get paymentStep4 => 'eSIM-ەکەت دەستبەجێ دوای پارەدان بەردەست دەبێت';

  @override
  String get paymentWaylNote =>
      'پلاتفۆرمی Wayl پێویستی بە ژمارەی واتسئاپە بۆ پشتڕاستکردنەوە، دواتر فۆڕمی کارتەکە دەردەکەوێت.';

  @override
  String get continueToPay => 'بەردەوامبوون بۆ پارەدان';

  @override
  String get paymentSheetHint => 'پارێزراو · FIB · زینکاش · Visa';

  @override
  String get fibPaymentTitle => 'پارەدان لە ڕێگەی FIB';

  @override
  String get fibPaymentSubtitle =>
      'ئەپی FIB بکەرەوە، پارەکە بنێرە و دواتر بگەڕێرەوە ئێرە.';

  @override
  String get fibAccountLabel => 'هەژماری FIB';

  @override
  String get fibPhoneLabel => 'ژمارەی مۆبایلی FIB';

  @override
  String get fibIbanLabel => 'IBAN';

  @override
  String get fibReferenceLabel => 'کۆدی سەرچاوە (لە بەشی تێبینی بینووسە)';

  @override
  String get fibPaymentNote =>
      'بڕی پارەکە بە تەواوی بنێرە بۆ هەژماری FIB، و دڵنیابە لە نووسینی \'کۆدی سەرچاوە\' لە بەشی تێبینی (Note).';

  @override
  String get fibOpenApp => 'کردنەوەی ئەپی FIB';

  @override
  String get fibOpenAppManually =>
      'ئەپی FIB لە مۆبایلەکەت بکەرەوە و پارەکە بنێرە.';

  @override
  String get fibMarkPaid => 'پارەکەم نارد';

  @override
  String get fibStepsTitle => 'چۆنیەتی پارەدان بە FIB';

  @override
  String get fibStep1 => 'ئەپی FIB لە مۆبایلەکەت بکەرەوە';

  @override
  String get fibStep2 => 'بڕی پارەکە بە تەواوی بنێرە';

  @override
  String get fibStep3 =>
      'دڵنیابە \'کۆدی سەرچاوە\' لە بەشی تێبینی (Note) دەنووسیت';

  @override
  String get fibStep4 =>
      'دوگمەی «پارەکەم نارد» دابگرە — ئێمە دڵنیای دەکەینەوە و eSIM-ەکەت پێ دەگەیەنین';

  @override
  String get fibSheetHint =>
      'گواستنەوەی دەستی FIB · لە ماوەی چەند کاتژمێرێکدا پشتڕاست دەکرێتەوە';

  @override
  String get fibManualPendingTitle => 'پارەدانەکە نێردرا';

  @override
  String get fibManualPendingSubtitle =>
      'پارەدانەکەت گەیشت، پاش پشتڕاستکردنەوەی لەلایەن تیمی ئێمەوە، eSIM-ەکەت لە بەشی \'eSIM-ەکانم\' دەردەکەوێت.';

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
  String get paymentBadgePopular => 'باوترین';

  @override
  String get paymentBadgeInstant => 'خێرا';

  @override
  String get paymentBadgeLocal => 'عێراق';

  @override
  String payAmount(String amount) {
    return 'پارەدان $amount';
  }

  @override
  String get securedByStripe => 'پارێزراو لەلایەن Stripe-ەوە';

  @override
  String copiedToClipboard(String label) {
    return '$label کۆپی کرا';
  }

  @override
  String get fibPayTitle => 'پارەدان بە FIB';

  @override
  String get fibScanTitle => 'بۆ پارەدان بە FIB سکان بکە';

  @override
  String get fibScanSubtitle => 'ئەپی FIB بکەرەوە و ئەم کۆدە QR-ە سکان بکە';

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
      'نەتوانرا ئەپی FIB بکرێتەوە. تکایە لەجیاتی ئەوە کۆدی QR-ەکە سکان بکە.';

  @override
  String get fibTransferDetails => 'وردەکارییەکانی گواستنەوە';

  @override
  String get cardCheckoutSubtitle =>
      'پارەدانەکەت لەسەر پەڕەیەکی پارێزراوی Stripe تەواو دەکەیت';

  @override
  String get cardPaymentTitle => 'پارەدانی پارێزراو بە کارت';

  @override
  String get cardPaymentNote =>
      'پارەدانەکەت لە ڕێگەی Stripe-ەوە تەواو بکە و eSIM-ەکەت ڕاستەوخۆ بەردەست دەبێت.';

  @override
  String get cardStepsTitle => 'چۆنیەتی پارەدان بە کارتی بانکی';

  @override
  String get cardStep1 =>
      'زانیارییەکانی کارتەکەت لە پەڕەیەکی پارێزراودا بنووسە';

  @override
  String get cardStep2 => 'پارەدانەکەت لە ڕێگەی Stripe-ەوە تەواو بکە';

  @override
  String get cardStep3 => 'eSIM-ەکەت دەستبەجێ لە بەشی «eSIM-ەکانم» دەردەکەوێت';

  @override
  String get cardSheetHint => 'شێوەزاری 256-bit · Stripe · Visa · Mastercard';

  @override
  String errorGeneric(String message) {
    return 'هەڵە: $message';
  }

  @override
  String get noPackages => 'هیچ پاکێجێک بەردەست نییە';

  @override
  String plansAvailable(int count) {
    return '$count پاکێج بەردەستە';
  }

  @override
  String get countryHeroDesc =>
      'پاکێجێکی ئینتەرنێت هەڵبژێرە. eSIM-ەکەت بە کۆدی QR وەربگرە — بێ پێویستی بە سەردانکردنی فرۆشگا.';

  @override
  String daysCount(int count) {
    return '$count ڕۆژ';
  }

  @override
  String get buy => 'کڕین';

  @override
  String get details => 'وردەکارییەکان';

  @override
  String get less => 'کەمتر';

  @override
  String get packageDetails => 'گەیاندنی eSIM · QR code · بێ سیمکارتی فیزیکی';

  @override
  String get unlimited => 'بێسنوور';

  @override
  String get filterAll => 'هەمووی';

  @override
  String get filterLimited => 'سنووردار';

  @override
  String get welcomeBack => 'بەخێربێیتەوە';

  @override
  String get createAccount => 'دروستکردنی هەژمار';

  @override
  String get signInTo => 'چوونەژوورەوە بۆ ';

  @override
  String get join => 'بەشداریکردن لە ';

  @override
  String get name => 'ناو';

  @override
  String get email => 'ئیمەیڵ';

  @override
  String get password => 'وشەی نهێنی';

  @override
  String get register => 'خۆتۆمارکردن';

  @override
  String get login => 'چوونەژوورەوە';

  @override
  String get continueWithGoogle => 'بەردەوامبوون لەگەڵ Google';

  @override
  String get continueWithApple => 'بەردەوامبوون لەگەڵ Apple';

  @override
  String get signInWithAccount => 'چوونەژوورەوە بە هەژمار';

  @override
  String get emailPasswordDesc => 'بە ئیمەیڵ و وشەی نهێنی';

  @override
  String get createAccountHint => 'ناو، ئیمەیڵ و وشەی نهێنییەکی نوێ بنووسە';

  @override
  String get confirmPassword => 'دڵنیاکردنەوەی وشەی نهێنی';

  @override
  String get fieldRequired => 'ئەم خانەیە پێویستە';

  @override
  String get invalidEmail => 'ئیمەیڵێکی دروست بنووسە';

  @override
  String get passwordMinLength => 'پێویستە وشەی نهێنی لانیکەم ٨ پیت بێت';

  @override
  String get passwordMismatch => 'وشە نهێنییەکان هاوتا نین';

  @override
  String get googleSignInDesc => 'تەنیا بە یەک کلیک · بە تەواوی پارێزراوە';

  @override
  String get signInDisclaimer => 'زانیارییەکانت بە پارێزراوی دەمێننەوە';

  @override
  String get signInWithSocial => 'یان ڕاستەوخۆ بە Google یان Apple بڕۆ ژوورەوە';

  @override
  String get haveAccount => 'هەژمارت هەیە؟ لێرەوە بچۆ ژوورەوە';

  @override
  String get noAccount => 'هەژمارێکی نوێ دروستبکە';

  @override
  String get loginSuccess => 'سەرکەوتووانە چوویتە ژوورەوە';

  @override
  String get canBuyNow => 'ئێستا دەتوانیت ئاسانتر eSIM بکڕیت';

  @override
  String get logout => 'چوونەدەرەوە';

  @override
  String get deleteAccount => 'سڕینەوەی هەژمار';

  @override
  String get deleteAccountTitle => 'دڵنیایت لە سڕینەوەی هەژمارەکەت؟';

  @override
  String get deleteAccountMessage =>
      'هەموو زانیارییەکانی هەژمارەکەت، داواکارییەکانت و eSIM-ەکانت بە یەکجاری دەسڕێنەوە و ناتوانیت بیانگەڕێنیتەوە.';

  @override
  String get deleteAccountConfirm => 'بەڵێ، بسڕەوە';

  @override
  String get cancel => 'پاشگەزبوونەوە';

  @override
  String get accountDeleted => 'هەژمارەکەت بە سەرکەوتوویی سڕایەوە';

  @override
  String get splashTagline => 'لە هەر شوێنێکی جیهان بیت، هەمیشە لەسەر هێڵ بە';

  @override
  String get language => 'زمان (Language)';

  @override
  String get english => 'English';

  @override
  String get arabic => 'عەرەبی';

  @override
  String get kurdish => 'کوردی';

  @override
  String get navStore => 'فرۆشگا';

  @override
  String get navMyEsims => 'eSIM-ەکانم';

  @override
  String get navProfile => 'هەژمار';

  @override
  String get myEsimsTitle => 'eSIM-ەکانم';

  @override
  String get myEsimsEmpty => 'تا ئێستا هیچ eSIM-ێکت نەکڕیوە';

  @override
  String get myEsimsLogin => 'بۆ بینینی eSIM-ەکانت پێویستە بچیتە ژوورەوە';

  @override
  String get myEsimsGoStore => 'بڕۆ بۆ فرۆشگا';

  @override
  String get profileTitle => 'هەژمارەکەم';

  @override
  String get profileGuest => 'میوان';

  @override
  String get profileGuestHint =>
      'بۆ بەڕێوەبردنی هەژمارەکەت و eSIM-ەکانت، بچۆ ژوورەوە.';

  @override
  String get statusActive => 'چالاک';

  @override
  String get statusExpired => 'بەسەرچوو';

  @override
  String get statusDepleted => 'تەواوبووە';

  @override
  String dataUsage(String used, String total) {
    return 'بەکارهاتوو: $used / $total';
  }

  @override
  String expiresOn(String date) {
    return 'ڕێکەوتی بەسەرچوون: $date';
  }

  @override
  String iccid(String value) {
    return 'ICCID: $value';
  }

  @override
  String get esimTapToInstall => 'کلیک بکە بۆ زانیاری بەکارهێنان و دامەزراندن';

  @override
  String get esimDetailTitle => 'وردەکارییەکانی eSIM';

  @override
  String get esimRefreshUsage => 'نوێکردنەوەی زانیاری';

  @override
  String get esimUsageTitle => 'بەکارهێنانی داتا';

  @override
  String get esimUsageUnavailable =>
      'دوای ئەوەی eSIM-ەکەت لە تۆڕەکەدا چالاک بوو، زانیاری بەکارهێنان لێرە دەردەکەوێت.';

  @override
  String esimUsageSummary(String used, String total) {
    return '$used بەکارهاتووە لە کۆی $total';
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
  String get esimUnlimitedHint => 'ئەم پاکێجە ئینتەرنێتی بێسنووری لەگەڵدایە.';

  @override
  String get esimStatusNotActive => 'هێشتا چالاک نەکراوە';

  @override
  String esimVoiceLeft(int remaining, int total) {
    return 'پەیوەندی: $remaining / $total خولەک';
  }

  @override
  String esimSmsLeft(int remaining, int total) {
    return 'کورتەنامە: $remaining / $total';
  }

  @override
  String get esimTabIphone => 'ئایفۆن';

  @override
  String get esimTabAndroid => 'ئەندرۆید';

  @override
  String get esimInstallTitle => 'دامەزراندنی eSIM';

  @override
  String get esimInstallHowTitle => 'دامەزراندنی eSIM';

  @override
  String get esimInstallHowSubtitle =>
      'جۆری مۆبایلەکەت هەڵبژێرە. لە ئایفۆن تەنها بە یەک کلیک، وە لە ئەندرۆید لە ڕێگەی سکانکردنی QR کۆدەوە دەبێت.';

  @override
  String get esimScanQr => 'ئەم کۆدی QR-ە سکان بکە';

  @override
  String get esimInstallOnIphone => 'دامەزراندن لەسەر ئایفۆن';

  @override
  String get esimInstallOnIphoneHint =>
      'لەسەر سیستەمی iOS 17.4 و بەرەو سەر باشترینە. ڕاستەوخۆ پەڕەی دامەزراندنی eSIM-ی ئەپڵ دەکاتەوە.';

  @override
  String get esimManualTitle => 'زانیارییەکان بە دەستی';

  @override
  String get esimManualSubtitle =>
      'ئەگەر QR کۆد یان یەک کلیک کاری نەکرد، کلیک لە زانیارییەکانی خوارەوە بکە بۆ کۆپیکردن و بە دەستی دایانمەزرێنە.';

  @override
  String get esimSmdpAddress => 'بەستەری SM-DP+';

  @override
  String get esimActivationCode => 'کۆدی چالاککردن (Activation)';

  @override
  String get esimConfirmationCode => 'کۆدی دڵنیاکردنەوە (Confirmation)';

  @override
  String get esimConfirmationOptional =>
      'تێبینی: Confirmation Code بەتاڵی جێبهێڵە مەگەر ئەوەی کۆمپانیای پەیوەندییەکە کۆدێکی تایبەتی پێدابیت.';

  @override
  String get esimStepsIphoneTitle => 'هەنگاوەکانی دامەزراندن لە ئایفۆن';

  @override
  String get esimStepIphone1 => 'بچۆ بۆ Settings → Cellular → Add eSIM';

  @override
  String get esimStepIphone2 =>
      'پاشان Use QR Code، یان Enter Details Manually هەڵبژێرە';

  @override
  String get esimStepIphone3 =>
      'زانیارییەکانی SM-DP+ و Activation Code لەوێ بنووسە';

  @override
  String get esimStepIphone4 =>
      'کاتێک گەیشتیتە وڵاتی مەبەست، Data Roaming هەڵبکە';

  @override
  String get esimStepsAndroidTitle => 'هەنگاوەکانی دامەزراندن لە ئەندرۆید';

  @override
  String get esimStepAndroid1 => 'بچۆ بۆ Settings → Network & internet → SIMs';

  @override
  String get esimStepAndroid2 => 'پاشان Download a SIM / Add eSIM هەڵبژێرە';

  @override
  String get esimStepAndroid3 => 'ئەو QR کۆدەی سەرەوە سکان بکە';

  @override
  String get esimStepAndroid4 =>
      'دڵنیابە لە هەڵکردنی Mobile data و Roaming بۆ ئەم eSIM-ە';

  @override
  String esimApnHint(String apn) {
    return 'ئەگەر پێویست بوو، ئەوا APN دابنێ بۆ: $apn';
  }

  @override
  String get esimRoamingHint =>
      'دوای دامەزراندن: دڵنیابە لە هەڵکردنی Data Roaming، وە ئەم eSIM-ە نوێیە وەک سەرچاوەی سەرەکی بۆ Mobile Data هەڵبژێرە.';

  @override
  String get esimOpenShareLink => 'کردنەوەی پەڕەی دامەزراندن';

  @override
  String esimShareCode(String code) {
    return 'کۆدی چوونەژوورەوە: $code';
  }

  @override
  String get esimOpenLinkFailed => 'کێشەیەک هەیە لە کردنەوەی بەستەرەکە';

  @override
  String get orderHistoryTitle => 'مێژووی داواکارییەکان';

  @override
  String get orderHistoryEmpty => 'تا ئێستا هیچ داواکارییەکت نەکردووە';

  @override
  String get orderStatusPending => 'چاوەڕوانی پارەدان';

  @override
  String get orderStatusPaid => 'لە جێبەجێکردندایە';

  @override
  String get orderStatusProcessing => 'ئامادەکردنی eSIM...';

  @override
  String get orderStatusCompleted => 'تەواوبوو';

  @override
  String get orderStatusFailed => 'سەرنەکەوت';

  @override
  String get completePayment => 'تەواوکردنی پارەدانەکە';

  @override
  String get orderAwaitingVerification => 'چاوەڕوانی پشتڕاستکردنەوە';

  @override
  String get termsTitle => 'مەرجەکانی بەکارهێنان';

  @override
  String get privacyTitle => 'پاراستنی زانیارییەکان';

  @override
  String get supportTitle => 'پشتگیری و یارمەتی';

  @override
  String get termsOfService => 'مەرجەکانی بەکارهێنان';

  @override
  String get privacyPolicy => 'پاراستنی زانیارییەکان';

  @override
  String get helpSupport => 'پشتگیری و یارمەتی';

  @override
  String get contactEmail => 'ئیمەیڵمان بۆ بنێرە';

  @override
  String get contactWhatsapp => 'نامە لە واتسئاپەوە';

  @override
  String get supportContactTitle => 'پەیوەندیمان پێوە بکە';

  @override
  String get supportFaqTitle => 'پرسیارە باوەکان (FAQ)';

  @override
  String get onboardingSkip => 'تێپەڕاندن';

  @override
  String get onboardingNext => 'دواتر';

  @override
  String get onboardingGetStarted => 'دەستپێبکە';

  @override
  String get onboardingSlide1Title => 'لە هەر کوێیەک بیت بەستراوە بە';

  @override
  String get onboardingSlide1Body =>
      'پاکێجی ئینتەرنێتی eSIM بۆ زیاتر لە ٢٠٠ وڵات. گەیاندنی دەستبەجێ — بێ پێویستی بە سیمکارتی فیزیکی.';

  @override
  String get onboardingSlide2Title => 'دامەزراندن لە چەند خولەکێکدا';

  @override
  String get onboardingSlide2Body =>
      'بۆ ئەندرۆید تەنها QR کۆدێک سکان بکە یان بۆ ئایفۆن بە یەک کلیک دایمەزرێنە. پاکێجەکە تەنها لە کاتی گەیشتن بە وڵاتی مەبەست چالاک دەبێت.';

  @override
  String get onboardingSlide3Title => 'پارەدان بە شێوازی ئاسان';

  @override
  String get onboardingSlide3Body =>
      'لە ڕێگەی FIB-ەوە بە دینار پارە بدە یان کارتی بانکی لە ڕێگەی Stripe بەکاربهێنە. دوای پارەدان ڕاستەوخۆ eSIM-ەکەت پێدەگات.';

  @override
  String get offlineTitle => 'هێڵی ئینتەرنێت نییە';

  @override
  String get offlineMessage =>
      'تکایە پەیوەندی ئینتەرنێتەکەت بپشکنە و دووبارە هەوڵبدەرەوە.';

  @override
  String get sessionExpired =>
      'کاتی چوونەژوورەوەت بەسەرچووە، تکایە دووبارە بچۆ ژوورەوە.';

  @override
  String get esimLowDataTitle => 'داتا کەم ماوە';

  @override
  String esimLowDataMessage(int percent) {
    return 'تەنها $percent% لە ئینتەرنێتەکەت ماوە. پێش ئەوەی تەواو بێت دەتوانیت پاکێجێکی تر بکرڕیت.';
  }

  @override
  String get esimExpirySoonTitle => 'پاکێجەکەت بەزوویی بەسەردەچێت';

  @override
  String esimExpirySoonMessage(int days) {
    return 'پاکێجەکەت لە ماوەی $days ڕۆژی تردا بەسەردەچێت. پێش ئەوەی بەسەر بچێت دەتوانیت نوێی بکەیتەوە.';
  }

  @override
  String get shareReceipt => 'هاوبەشکردنی وەسڵ';

  @override
  String get receiptTitle => 'وەسڵی eSIM KRD';

  @override
  String get promoCodeLabel => 'کۆدی داشکاندن (Promo Code)';

  @override
  String get promoCodeHint => 'کۆدەکە لێرە بنووسە';

  @override
  String get promoApply => 'جێبەجێکردن';

  @override
  String get promoDiscount => 'داشکاندن';

  @override
  String get topUpTitle => 'زیادکردنی داتا (Top-up)';

  @override
  String get topUpSubtitle => 'ئەم eSIM-ە نوێ بکەرەوە یان داتای بۆ زیاد بکە.';

  @override
  String get topUpAction => 'Top up / نوێکردنەوە';

  @override
  String get referralTitle => 'بانگهێشتکردنی هاوڕێ';

  @override
  String get referralSubtitle =>
      'کۆدەکەت هاوبەش بکە و هاوڕێیەکانت بانگهێشت بکە.';

  @override
  String get referralShare => 'لینکەکە بڵاوبکەرەوە';

  @override
  String referralShareMessage(String code) {
    return 'ئینتەرنێتی باوەڕپێکراو لە هەر کوێیەکی جیهان لەگەڵ eSIM KRD! ئەم کۆدەی من بەکاربهێنە بۆ داشکاندن: $code';
  }

  @override
  String referralCount(int count) {
    return '$count هاوڕێ لە ڕێگەی تۆوە بەشدارییان کردووە';
  }

  @override
  String get currencyDisplay => 'پیشاندانی دراوەکان';

  @override
  String get currencyBoth => 'USD + IQD';

  @override
  String get currencyUsd => 'Only USD';

  @override
  String get currencyIqd => 'Only IQD';
}
