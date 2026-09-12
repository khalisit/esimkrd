// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'eSIM KRD';

  @override
  String get heroTitlePart1 => 'Travel ';

  @override
  String get heroTitleHighlight => 'connected';

  @override
  String get heroTitlePart2 => ', anywhere';

  @override
  String get heroSubtitle =>
      'eSIM packages for 200+ countries. Instant delivery, no physical SIM.';

  @override
  String destinationsCount(int count) {
    return '$count+ destinations';
  }

  @override
  String get getStarted => 'Get started';

  @override
  String get browsePlans => 'Browse plans';

  @override
  String get searchCountries => 'Search countries...';

  @override
  String get kurdistanRegion => 'Kurdistan & Region';

  @override
  String get kurdistanRegionSubtitle => 'Plans for Iraq, Turkey, Europe & more';

  @override
  String get popularDestinations => 'Popular destinations';

  @override
  String get allCountries => 'All countries';

  @override
  String get noResults => 'No results found';

  @override
  String get loadingCountries => 'Loading countries...';

  @override
  String get loadingPackages => 'Loading packages...';

  @override
  String get loading => 'Loading...';

  @override
  String get apiError => 'Cannot reach API';

  @override
  String get retry => 'Try again';

  @override
  String get loginRequired => 'Please sign in first';

  @override
  String get orderCreated => 'Order created successfully';

  @override
  String get openingPayment => 'Opening payment page...';

  @override
  String get paymentUrlMissing => 'Payment link was not returned';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentComplete =>
      'Payment completed — your eSIM will appear shortly';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get orderSummary => 'Order summary';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalIqd => 'Total (IQD)';

  @override
  String orderNumber(int id) {
    return 'Order #$id';
  }

  @override
  String get paySecurely => 'Pay securely';

  @override
  String get securePayment => 'Secure payment';

  @override
  String get poweredByWayl => 'FIB · ZainCash · Visa';

  @override
  String get checkoutDisclaimer =>
      'Your eSIM will be delivered instantly after payment is confirmed.';

  @override
  String get loadingPayment => 'Loading secure checkout...';

  @override
  String get cancelPayment => 'Cancel payment?';

  @override
  String get cancelPaymentConfirm =>
      'Your order is saved. You can complete payment later from My eSIMs.';

  @override
  String get stay => 'Continue payment';

  @override
  String get leave => 'Leave';

  @override
  String get confirmingPayment => 'Confirming payment';

  @override
  String get confirmingPaymentSubtitle =>
      'Please wait while we verify your transaction...';

  @override
  String get paymentSuccess => 'Payment successful!';

  @override
  String get paymentSuccessSubtitle =>
      'Your eSIM is being prepared and will appear in My eSIMs shortly.';

  @override
  String get paymentPending => 'Payment processing';

  @override
  String get paymentPendingSubtitle =>
      'We\'re still waiting for confirmation. Check My eSIMs in a few minutes.';

  @override
  String get paymentFailed => 'Could not confirm payment';

  @override
  String get paymentFailedSubtitle =>
      'If you were charged, contact support with your order number.';

  @override
  String get viewMyEsims => 'View my eSIMs';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get paymentStepsTitle => 'How to pay with Visa / card';

  @override
  String get paymentStep1 => 'Enter WhatsApp number and confirm the code';

  @override
  String get paymentStep2 => 'Tap the «Cards» tab (Visa / Mastercard)';

  @override
  String get paymentStep3 => 'Enter card number, expiry and CVV';

  @override
  String get paymentStep4 => 'Your eSIM arrives instantly after payment';

  @override
  String get paymentWaylNote =>
      'Wayl requires WhatsApp login first — then the card form appears.';

  @override
  String get continueToPay => 'Continue to payment';

  @override
  String get paymentSheetHint => 'FIB · ZainCash · Visa';

  @override
  String get fibPaymentTitle => 'Pay with FIB';

  @override
  String get fibPaymentSubtitle =>
      'Open FIB, send the amount, then return here.';

  @override
  String get fibAccountLabel => 'FIB account';

  @override
  String get fibPhoneLabel => 'FIB phone number';

  @override
  String get fibIbanLabel => 'IBAN';

  @override
  String get fibReferenceLabel => 'Reference (put in note)';

  @override
  String get fibPaymentNote =>
      'Send the exact IQD amount to the FIB account below. You must include the reference in the transfer note.';

  @override
  String get fibOpenApp => 'Open FIB app';

  @override
  String get fibOpenAppManually =>
      'Open the FIB app on your phone, then send the payment.';

  @override
  String get fibMarkPaid => 'I have paid';

  @override
  String get fibStepsTitle => 'How to pay with FIB';

  @override
  String get fibStep1 => 'Open the FIB app on your phone';

  @override
  String get fibStep2 => 'Send the exact IQD amount shown';

  @override
  String get fibStep3 => 'Put the reference code in the transfer note';

  @override
  String get fibStep4 => 'Tap «I have paid» — we verify and deliver your eSIM';

  @override
  String get fibSheetHint =>
      'Manual FIB transfer · verified within a few hours';

  @override
  String get fibManualPendingTitle => 'Payment submitted';

  @override
  String get fibManualPendingSubtitle =>
      'We received your confirmation. Once we verify the FIB transfer, your eSIM will appear in My eSIMs.';

  @override
  String get paymentMethodTitle => 'Payment method';

  @override
  String get paymentMethodSubtitle =>
      'Secure checkout with Visa, Mastercard & Apple Pay';

  @override
  String get paymentMethodFib => 'Pay with FIB';

  @override
  String get paymentMethodFibDesc => 'Bank transfer in Iraqi Dinar (IQD)';

  @override
  String get paymentMethodCard => 'Pay by card';

  @override
  String get paymentMethodCardDesc => 'Visa, Mastercard & Apple Pay';

  @override
  String get paymentBadgePopular => 'Popular';

  @override
  String get paymentBadgeInstant => 'Instant delivery';

  @override
  String get paymentBadgeLocal => 'Iraq';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get securedByStripe => 'Secured by Stripe';

  @override
  String copiedToClipboard(String label) {
    return '$label copied';
  }

  @override
  String get fibPayTitle => 'FIB payment';

  @override
  String get fibScanTitle => 'Scan to pay with FIB';

  @override
  String get fibScanSubtitle => 'Open the FIB app and scan this QR code';

  @override
  String get fibReadableCode => 'Payment code';

  @override
  String get fibOpenAppTitle => 'Or open the FIB app directly';

  @override
  String get fibPersonalApp => 'Open FIB Personal';

  @override
  String get fibBusinessApp => 'Open FIB Business';

  @override
  String get fibWaitingPayment =>
      'Waiting for your payment… this updates automatically.';

  @override
  String get fibCheckStatus => 'I have paid — check now';

  @override
  String get fibAppNotInstalled =>
      'Couldn\'t open the FIB app. Please scan the QR code instead.';

  @override
  String get fibTransferDetails => 'Transfer details';

  @override
  String get cardCheckoutSubtitle =>
      'You will complete payment on Stripe\'s secure checkout page';

  @override
  String get cardPaymentTitle => 'Secure card payment';

  @override
  String get cardPaymentNote =>
      'Complete payment on Stripe\'s secure checkout. Your eSIM is delivered automatically.';

  @override
  String get cardStepsTitle => 'How to pay by card';

  @override
  String get cardStep1 => 'Enter your card details on the secure page';

  @override
  String get cardStep2 => 'Complete payment — powered by Stripe';

  @override
  String get cardStep3 => 'Your eSIM arrives instantly in My eSIMs';

  @override
  String get cardSheetHint => '256-bit encryption · Stripe · Visa · Mastercard';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get noPackages => 'No packages available';

  @override
  String plansAvailable(int count) {
    return '$count plans available';
  }

  @override
  String get countryHeroDesc =>
      'Choose your data plan. Instant eSIM via QR code — no store visit needed.';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get buy => 'Buy';

  @override
  String get details => 'Details';

  @override
  String get less => 'Less';

  @override
  String get packageDetails =>
      'Instant eSIM delivery · QR code · No physical SIM needed';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get filterAll => 'All';

  @override
  String get filterLimited => 'Limited';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create account';

  @override
  String get signInTo => 'Sign in to ';

  @override
  String get join => 'Join ';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get register => 'Register';

  @override
  String get login => 'Sign in';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get signInWithAccount => 'Sign in with account';

  @override
  String get emailPasswordDesc => 'Email and password';

  @override
  String get createAccountHint => 'Enter your name, email, and password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get googleSignInDesc => 'One tap · Secure';

  @override
  String get signInDisclaimer => 'Your sign-in is encrypted and secure';

  @override
  String get signInWithSocial => 'Or continue with Google or Apple';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get noAccount => 'Create a new account';

  @override
  String get loginSuccess => 'Signed in successfully';

  @override
  String get canBuyNow => 'You can now purchase eSIM';

  @override
  String get logout => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountMessage =>
      'This will permanently delete your account, orders, and eSIM data. This action cannot be undone.';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get accountDeleted => 'Your account has been deleted';

  @override
  String get splashTagline => 'Travel connected, anywhere';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get kurdish => 'Kurdish';

  @override
  String get navStore => 'Store';

  @override
  String get navMyEsims => 'My eSIMs';

  @override
  String get navProfile => 'Profile';

  @override
  String get myEsimsTitle => 'My eSIMs';

  @override
  String get myEsimsEmpty => 'You haven\'t purchased any eSIM yet';

  @override
  String get myEsimsLogin => 'Sign in to view your eSIMs';

  @override
  String get myEsimsGoStore => 'Browse store';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGuest => 'Guest';

  @override
  String get profileGuestHint => 'Sign in to manage your account and eSIMs';

  @override
  String get statusActive => 'Active';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusDepleted => 'Depleted';

  @override
  String dataUsage(String used, String total) {
    return 'Data: $used / $total';
  }

  @override
  String expiresOn(String date) {
    return 'Expires: $date';
  }

  @override
  String iccid(String value) {
    return 'ICCID: $value';
  }

  @override
  String get esimTapToInstall => 'Tap for usage & install';

  @override
  String get esimDetailTitle => 'eSIM details';

  @override
  String get esimRefreshUsage => 'Refresh usage';

  @override
  String get esimUsageTitle => 'Data usage';

  @override
  String get esimUsageUnavailable =>
      'Usage will appear after the eSIM becomes active on the network.';

  @override
  String esimUsageSummary(String used, String total) {
    return '$used used of $total';
  }

  @override
  String get esimUsed => 'Used';

  @override
  String get esimRemaining => 'Left';

  @override
  String get esimTotal => 'Total';

  @override
  String get esimDataLeft => 'left';

  @override
  String get esimUnlimited => 'Unlimited';

  @override
  String get esimUnlimitedHint => 'This plan has unlimited data.';

  @override
  String get esimStatusNotActive => 'Not activated';

  @override
  String esimVoiceLeft(int remaining, int total) {
    return 'Voice: $remaining / $total min';
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
  String get esimInstallTitle => 'Install eSIM';

  @override
  String get esimInstallHowTitle => 'Install your eSIM';

  @override
  String get esimInstallHowSubtitle =>
      'Choose your phone type. One-tap install on iPhone, or scan the QR on Android.';

  @override
  String get esimScanQr => 'Scan this QR code';

  @override
  String get esimInstallOnIphone => 'Install on iPhone';

  @override
  String get esimInstallOnIphoneHint =>
      'Best on iOS 17.4+. Opens Apple eSIM setup on this iPhone.';

  @override
  String get esimManualTitle => 'Manual codes';

  @override
  String get esimManualSubtitle =>
      'Tap to copy. Use if QR or one-tap install is unavailable.';

  @override
  String get esimSmdpAddress => 'SM-DP+ Address';

  @override
  String get esimActivationCode => 'Activation Code';

  @override
  String get esimConfirmationCode => 'Confirmation Code';

  @override
  String get esimConfirmationOptional =>
      'Confirmation Code: leave empty unless your carrier provided one.';

  @override
  String get esimStepsIphoneTitle => 'iPhone steps';

  @override
  String get esimStepIphone1 => 'Settings → Cellular → Add eSIM';

  @override
  String get esimStepIphone2 => 'Use QR Code, or Enter Details Manually';

  @override
  String get esimStepIphone3 => 'Paste SM-DP+ Address and Activation Code';

  @override
  String get esimStepIphone4 =>
      'Enable Data Roaming for this eSIM when you arrive';

  @override
  String get esimStepsAndroidTitle => 'Android steps';

  @override
  String get esimStepAndroid1 => 'Settings → Network & internet → SIMs';

  @override
  String get esimStepAndroid2 => 'Download a SIM / Add eSIM';

  @override
  String get esimStepAndroid3 => 'Scan the QR code above';

  @override
  String get esimStepAndroid4 => 'Enable Mobile data + Roaming for this eSIM';

  @override
  String esimApnHint(String apn) {
    return 'If needed, set APN to: $apn';
  }

  @override
  String get esimRoamingHint =>
      'After install: turn on Data Roaming and select this eSIM for Mobile Data.';

  @override
  String get esimOpenShareLink => 'Open install page';

  @override
  String esimShareCode(String code) {
    return 'Access code: $code';
  }

  @override
  String get esimOpenLinkFailed => 'Could not open the link';

  @override
  String get orderHistoryTitle => 'Order history';

  @override
  String get orderHistoryEmpty => 'No orders yet';

  @override
  String get orderStatusPending => 'Payment pending';

  @override
  String get orderStatusPaid => 'Processing payment';

  @override
  String get orderStatusProcessing => 'Preparing eSIM';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusFailed => 'Failed';

  @override
  String get completePayment => 'Complete payment';

  @override
  String get orderAwaitingVerification => 'Awaiting verification';

  @override
  String get termsTitle => 'Terms of service';

  @override
  String get privacyTitle => 'Privacy policy';

  @override
  String get supportTitle => 'Help & support';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get helpSupport => 'Help & support';

  @override
  String get contactEmail => 'Email us';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get supportContactTitle => 'Contact us';

  @override
  String get supportFaqTitle => 'Common questions';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSlide1Title => 'Travel connected, anywhere';

  @override
  String get onboardingSlide1Body =>
      'Browse eSIM data plans for 200+ countries. Instant digital delivery — no physical SIM card needed.';

  @override
  String get onboardingSlide2Title => 'Install in minutes';

  @override
  String get onboardingSlide2Body =>
      'Scan a QR code on Android or use one-tap install on iPhone. Your plan activates when you connect abroad.';

  @override
  String get onboardingSlide3Title => 'Pay securely';

  @override
  String get onboardingSlide3Body =>
      'Pay with FIB in Iraqi Dinar or by card with Stripe. Your eSIM appears in My eSIMs after payment.';

  @override
  String get offlineTitle => 'No internet connection';

  @override
  String get offlineMessage => 'Check your connection and try again.';

  @override
  String get sessionExpired => 'Your session expired. Please sign in again.';

  @override
  String get esimLowDataTitle => 'Low data remaining';

  @override
  String esimLowDataMessage(int percent) {
    return 'Only $percent% of your data is left. Consider topping up before you run out.';
  }

  @override
  String get esimExpirySoonTitle => 'Plan expiring soon';

  @override
  String esimExpirySoonMessage(int days) {
    return 'Your plan expires in $days days. Renew before you travel again.';
  }

  @override
  String get shareReceipt => 'Share receipt';

  @override
  String get receiptTitle => 'eSIM KRD Receipt';

  @override
  String get promoCodeLabel => 'Promo code';

  @override
  String get promoCodeHint => 'Enter code';

  @override
  String get promoApply => 'Apply';

  @override
  String get promoDiscount => 'Discount';

  @override
  String get topUpTitle => 'Add more data';

  @override
  String get topUpSubtitle => 'Renew or top up this eSIM with a new package.';

  @override
  String get topUpAction => 'Top up / renew';

  @override
  String get referralTitle => 'Invite friends';

  @override
  String get referralSubtitle =>
      'Share your code. Friends get a great deal and you grow the community.';

  @override
  String get referralShare => 'Share invite link';

  @override
  String referralShareMessage(String code) {
    return 'Get travel eSIM with eSIM KRD! Use my code: $code';
  }

  @override
  String referralCount(int count) {
    return '$count friends joined';
  }

  @override
  String get currencyDisplay => 'Currency display';

  @override
  String get currencyBoth => 'USD + IQD';

  @override
  String get currencyUsd => 'USD only';

  @override
  String get currencyIqd => 'IQD only';
}
