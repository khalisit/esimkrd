import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ku.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ku'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'eSIM KRD'**
  String get appTitle;

  /// No description provided for @heroTitlePart1.
  ///
  /// In en, this message translates to:
  /// **'Travel '**
  String get heroTitlePart1;

  /// No description provided for @heroTitleHighlight.
  ///
  /// In en, this message translates to:
  /// **'connected'**
  String get heroTitleHighlight;

  /// No description provided for @heroTitlePart2.
  ///
  /// In en, this message translates to:
  /// **', anywhere'**
  String get heroTitlePart2;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'eSIM packages for 200+ countries. Instant delivery, no physical SIM.'**
  String get heroSubtitle;

  /// No description provided for @destinationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count}+ destinations'**
  String destinationsCount(int count);

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @browsePlans.
  ///
  /// In en, this message translates to:
  /// **'Browse plans'**
  String get browsePlans;

  /// No description provided for @searchCountries.
  ///
  /// In en, this message translates to:
  /// **'Search countries...'**
  String get searchCountries;

  /// No description provided for @kurdistanRegion.
  ///
  /// In en, this message translates to:
  /// **'Kurdistan & Region'**
  String get kurdistanRegion;

  /// No description provided for @kurdistanRegionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plans for Iraq, Turkey, Europe & more'**
  String get kurdistanRegionSubtitle;

  /// No description provided for @popularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular destinations'**
  String get popularDestinations;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get allCountries;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @loadingCountries.
  ///
  /// In en, this message translates to:
  /// **'Loading countries...'**
  String get loadingCountries;

  /// No description provided for @loadingPackages.
  ///
  /// In en, this message translates to:
  /// **'Loading packages...'**
  String get loadingPackages;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach API'**
  String get apiError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first'**
  String get loginRequired;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get orderCreated;

  /// No description provided for @openingPayment.
  ///
  /// In en, this message translates to:
  /// **'Opening payment page...'**
  String get openingPayment;

  /// No description provided for @paymentUrlMissing.
  ///
  /// In en, this message translates to:
  /// **'Payment link was not returned'**
  String get paymentUrlMissing;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @paymentComplete.
  ///
  /// In en, this message translates to:
  /// **'Payment completed — your eSIM will appear shortly'**
  String get paymentComplete;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get orderSummary;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @totalIqd.
  ///
  /// In en, this message translates to:
  /// **'Total (IQD)'**
  String get totalIqd;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(int id);

  /// No description provided for @paySecurely.
  ///
  /// In en, this message translates to:
  /// **'Pay securely'**
  String get paySecurely;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get securePayment;

  /// No description provided for @poweredByWayl.
  ///
  /// In en, this message translates to:
  /// **'FIB · ZainCash · Visa'**
  String get poweredByWayl;

  /// No description provided for @checkoutDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Your eSIM will be delivered instantly after payment is confirmed.'**
  String get checkoutDisclaimer;

  /// No description provided for @loadingPayment.
  ///
  /// In en, this message translates to:
  /// **'Loading secure checkout...'**
  String get loadingPayment;

  /// No description provided for @cancelPayment.
  ///
  /// In en, this message translates to:
  /// **'Cancel payment?'**
  String get cancelPayment;

  /// No description provided for @cancelPaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your order is saved. You can complete payment later from My eSIMs.'**
  String get cancelPaymentConfirm;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Continue payment'**
  String get stay;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @confirmingPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirming payment'**
  String get confirmingPayment;

  /// No description provided for @confirmingPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we verify your transaction...'**
  String get confirmingPaymentSubtitle;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get paymentSuccess;

  /// No description provided for @paymentSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your eSIM is being prepared and will appear in My eSIMs shortly.'**
  String get paymentSuccessSubtitle;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment processing'**
  String get paymentPending;

  /// No description provided for @paymentPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re still waiting for confirmation. Check My eSIMs in a few minutes.'**
  String get paymentPendingSubtitle;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm payment'**
  String get paymentFailed;

  /// No description provided for @paymentFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you were charged, contact support with your order number.'**
  String get paymentFailedSubtitle;

  /// No description provided for @viewMyEsims.
  ///
  /// In en, this message translates to:
  /// **'View my eSIMs'**
  String get viewMyEsims;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continueShopping;

  /// No description provided for @paymentStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to pay with Visa / card'**
  String get paymentStepsTitle;

  /// No description provided for @paymentStep1.
  ///
  /// In en, this message translates to:
  /// **'Enter WhatsApp number and confirm the code'**
  String get paymentStep1;

  /// No description provided for @paymentStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap the «Cards» tab (Visa / Mastercard)'**
  String get paymentStep2;

  /// No description provided for @paymentStep3.
  ///
  /// In en, this message translates to:
  /// **'Enter card number, expiry and CVV'**
  String get paymentStep3;

  /// No description provided for @paymentStep4.
  ///
  /// In en, this message translates to:
  /// **'Your eSIM arrives instantly after payment'**
  String get paymentStep4;

  /// No description provided for @paymentWaylNote.
  ///
  /// In en, this message translates to:
  /// **'Wayl requires WhatsApp login first — then the card form appears.'**
  String get paymentWaylNote;

  /// No description provided for @continueToPay.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get continueToPay;

  /// No description provided for @paymentSheetHint.
  ///
  /// In en, this message translates to:
  /// **'FIB · ZainCash · Visa'**
  String get paymentSheetHint;

  /// No description provided for @fibPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay with FIB'**
  String get fibPaymentTitle;

  /// No description provided for @fibPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open FIB, send the amount, then return here.'**
  String get fibPaymentSubtitle;

  /// No description provided for @fibAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'FIB account'**
  String get fibAccountLabel;

  /// No description provided for @fibPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'FIB phone number'**
  String get fibPhoneLabel;

  /// No description provided for @fibIbanLabel.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get fibIbanLabel;

  /// No description provided for @fibReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference (put in note)'**
  String get fibReferenceLabel;

  /// No description provided for @fibPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Send the exact IQD amount to the FIB account below. You must include the reference in the transfer note.'**
  String get fibPaymentNote;

  /// No description provided for @fibOpenApp.
  ///
  /// In en, this message translates to:
  /// **'Open FIB app'**
  String get fibOpenApp;

  /// No description provided for @fibOpenAppManually.
  ///
  /// In en, this message translates to:
  /// **'Open the FIB app on your phone, then send the payment.'**
  String get fibOpenAppManually;

  /// No description provided for @fibMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'I have paid'**
  String get fibMarkPaid;

  /// No description provided for @fibStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to pay with FIB'**
  String get fibStepsTitle;

  /// No description provided for @fibStep1.
  ///
  /// In en, this message translates to:
  /// **'Open the FIB app on your phone'**
  String get fibStep1;

  /// No description provided for @fibStep2.
  ///
  /// In en, this message translates to:
  /// **'Send the exact IQD amount shown'**
  String get fibStep2;

  /// No description provided for @fibStep3.
  ///
  /// In en, this message translates to:
  /// **'Put the reference code in the transfer note'**
  String get fibStep3;

  /// No description provided for @fibStep4.
  ///
  /// In en, this message translates to:
  /// **'Tap «I have paid» — we verify and deliver your eSIM'**
  String get fibStep4;

  /// No description provided for @fibSheetHint.
  ///
  /// In en, this message translates to:
  /// **'Manual FIB transfer · verified within a few hours'**
  String get fibSheetHint;

  /// No description provided for @fibManualPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment submitted'**
  String get fibManualPendingTitle;

  /// No description provided for @fibManualPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We received your confirmation. Once we verify the FIB transfer, your eSIM will appear in My eSIMs.'**
  String get fibManualPendingSubtitle;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodTitle;

  /// No description provided for @paymentMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure checkout with Visa, Mastercard & Apple Pay'**
  String get paymentMethodSubtitle;

  /// No description provided for @paymentMethodFib.
  ///
  /// In en, this message translates to:
  /// **'Pay with FIB'**
  String get paymentMethodFib;

  /// No description provided for @paymentMethodFibDesc.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer in Iraqi Dinar (IQD)'**
  String get paymentMethodFibDesc;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Pay by card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard & Apple Pay'**
  String get paymentMethodCardDesc;

  /// No description provided for @paymentBadgePopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get paymentBadgePopular;

  /// No description provided for @paymentBadgeInstant.
  ///
  /// In en, this message translates to:
  /// **'Instant delivery'**
  String get paymentBadgeInstant;

  /// No description provided for @paymentBadgeLocal.
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get paymentBadgeLocal;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payAmount(String amount);

  /// No description provided for @securedByStripe.
  ///
  /// In en, this message translates to:
  /// **'Secured by Stripe'**
  String get securedByStripe;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String copiedToClipboard(String label);

  /// No description provided for @fibPayTitle.
  ///
  /// In en, this message translates to:
  /// **'FIB payment'**
  String get fibPayTitle;

  /// No description provided for @fibScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay with FIB'**
  String get fibScanTitle;

  /// No description provided for @fibScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the FIB app and scan this QR code'**
  String get fibScanSubtitle;

  /// No description provided for @fibReadableCode.
  ///
  /// In en, this message translates to:
  /// **'Payment code'**
  String get fibReadableCode;

  /// No description provided for @fibOpenAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Or open the FIB app directly'**
  String get fibOpenAppTitle;

  /// No description provided for @fibPersonalApp.
  ///
  /// In en, this message translates to:
  /// **'Open FIB Personal'**
  String get fibPersonalApp;

  /// No description provided for @fibBusinessApp.
  ///
  /// In en, this message translates to:
  /// **'Open FIB Business'**
  String get fibBusinessApp;

  /// No description provided for @fibWaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your payment… this updates automatically.'**
  String get fibWaitingPayment;

  /// No description provided for @fibCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'I have paid — check now'**
  String get fibCheckStatus;

  /// No description provided for @fibAppNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the FIB app. Please scan the QR code instead.'**
  String get fibAppNotInstalled;

  /// No description provided for @fibTransferDetails.
  ///
  /// In en, this message translates to:
  /// **'Transfer details'**
  String get fibTransferDetails;

  /// No description provided for @cardCheckoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You will complete payment on Stripe\'s secure checkout page'**
  String get cardCheckoutSubtitle;

  /// No description provided for @cardPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure card payment'**
  String get cardPaymentTitle;

  /// No description provided for @cardPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Complete payment on Stripe\'s secure checkout. Your eSIM is delivered automatically.'**
  String get cardPaymentNote;

  /// No description provided for @cardStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to pay by card'**
  String get cardStepsTitle;

  /// No description provided for @cardStep1.
  ///
  /// In en, this message translates to:
  /// **'Enter your card details on the secure page'**
  String get cardStep1;

  /// No description provided for @cardStep2.
  ///
  /// In en, this message translates to:
  /// **'Complete payment — powered by Stripe'**
  String get cardStep2;

  /// No description provided for @cardStep3.
  ///
  /// In en, this message translates to:
  /// **'Your eSIM arrives instantly in My eSIMs'**
  String get cardStep3;

  /// No description provided for @cardSheetHint.
  ///
  /// In en, this message translates to:
  /// **'256-bit encryption · Stripe · Visa · Mastercard'**
  String get cardSheetHint;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @noPackages.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get noPackages;

  /// No description provided for @plansAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} plans available'**
  String plansAvailable(int count);

  /// No description provided for @countryHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your data plan. Instant eSIM via QR code — no store visit needed.'**
  String get countryHeroDesc;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// No description provided for @packageDetails.
  ///
  /// In en, this message translates to:
  /// **'Instant eSIM delivery · QR code · No physical SIM needed'**
  String get packageDetails;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get filterLimited;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @signInTo.
  ///
  /// In en, this message translates to:
  /// **'Sign in to '**
  String get signInTo;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join '**
  String get join;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @signInWithAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in with account'**
  String get signInWithAccount;

  /// No description provided for @emailPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Email and password'**
  String get emailPasswordDesc;

  /// No description provided for @createAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name, email, and password'**
  String get createAccountHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @googleSignInDesc.
  ///
  /// In en, this message translates to:
  /// **'One tap · Secure'**
  String get googleSignInDesc;

  /// No description provided for @signInDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Your sign-in is encrypted and secure'**
  String get signInDisclaimer;

  /// No description provided for @signInWithSocial.
  ///
  /// In en, this message translates to:
  /// **'Or continue with Google or Apple'**
  String get signInWithSocial;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get noAccount;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get loginSuccess;

  /// No description provided for @canBuyNow.
  ///
  /// In en, this message translates to:
  /// **'You can now purchase eSIM'**
  String get canBuyNow;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account, orders, and eSIM data. This action cannot be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get accountDeleted;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Travel connected, anywhere'**
  String get splashTagline;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @kurdish.
  ///
  /// In en, this message translates to:
  /// **'Kurdish'**
  String get kurdish;

  /// No description provided for @navStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get navStore;

  /// No description provided for @navMyEsims.
  ///
  /// In en, this message translates to:
  /// **'My eSIMs'**
  String get navMyEsims;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @myEsimsTitle.
  ///
  /// In en, this message translates to:
  /// **'My eSIMs'**
  String get myEsimsTitle;

  /// No description provided for @myEsimsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t purchased any eSIM yet'**
  String get myEsimsEmpty;

  /// No description provided for @myEsimsLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your eSIMs'**
  String get myEsimsLogin;

  /// No description provided for @myEsimsGoStore.
  ///
  /// In en, this message translates to:
  /// **'Browse store'**
  String get myEsimsGoStore;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuest;

  /// No description provided for @profileGuestHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your account and eSIMs'**
  String get profileGuestHint;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @statusDepleted.
  ///
  /// In en, this message translates to:
  /// **'Depleted'**
  String get statusDepleted;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data: {used} / {total}'**
  String dataUsage(String used, String total);

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String expiresOn(String date);

  /// No description provided for @iccid.
  ///
  /// In en, this message translates to:
  /// **'ICCID: {value}'**
  String iccid(String value);

  /// No description provided for @esimTapToInstall.
  ///
  /// In en, this message translates to:
  /// **'Tap for usage & install'**
  String get esimTapToInstall;

  /// No description provided for @esimDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'eSIM details'**
  String get esimDetailTitle;

  /// No description provided for @esimRefreshUsage.
  ///
  /// In en, this message translates to:
  /// **'Refresh usage'**
  String get esimRefreshUsage;

  /// No description provided for @esimUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data usage'**
  String get esimUsageTitle;

  /// No description provided for @esimUsageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Usage will appear after the eSIM becomes active on the network.'**
  String get esimUsageUnavailable;

  /// No description provided for @esimUsageSummary.
  ///
  /// In en, this message translates to:
  /// **'{used} used of {total}'**
  String esimUsageSummary(String used, String total);

  /// No description provided for @esimUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get esimUsed;

  /// No description provided for @esimRemaining.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get esimRemaining;

  /// No description provided for @esimTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get esimTotal;

  /// No description provided for @esimDataLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get esimDataLeft;

  /// No description provided for @esimUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get esimUnlimited;

  /// No description provided for @esimUnlimitedHint.
  ///
  /// In en, this message translates to:
  /// **'This plan has unlimited data.'**
  String get esimUnlimitedHint;

  /// No description provided for @esimStatusNotActive.
  ///
  /// In en, this message translates to:
  /// **'Not activated'**
  String get esimStatusNotActive;

  /// No description provided for @esimVoiceLeft.
  ///
  /// In en, this message translates to:
  /// **'Voice: {remaining} / {total} min'**
  String esimVoiceLeft(int remaining, int total);

  /// No description provided for @esimSmsLeft.
  ///
  /// In en, this message translates to:
  /// **'SMS: {remaining} / {total}'**
  String esimSmsLeft(int remaining, int total);

  /// No description provided for @esimTabIphone.
  ///
  /// In en, this message translates to:
  /// **'iPhone'**
  String get esimTabIphone;

  /// No description provided for @esimTabAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get esimTabAndroid;

  /// No description provided for @esimInstallTitle.
  ///
  /// In en, this message translates to:
  /// **'Install eSIM'**
  String get esimInstallTitle;

  /// No description provided for @esimInstallHowTitle.
  ///
  /// In en, this message translates to:
  /// **'Install your eSIM'**
  String get esimInstallHowTitle;

  /// No description provided for @esimInstallHowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your phone type. One-tap install on iPhone, or scan the QR on Android.'**
  String get esimInstallHowSubtitle;

  /// No description provided for @esimScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code'**
  String get esimScanQr;

  /// No description provided for @esimInstallOnIphone.
  ///
  /// In en, this message translates to:
  /// **'Install on iPhone'**
  String get esimInstallOnIphone;

  /// No description provided for @esimInstallOnIphoneHint.
  ///
  /// In en, this message translates to:
  /// **'Best on iOS 17.4+. Opens Apple eSIM setup on this iPhone.'**
  String get esimInstallOnIphoneHint;

  /// No description provided for @esimManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual codes'**
  String get esimManualTitle;

  /// No description provided for @esimManualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to copy. Use if QR or one-tap install is unavailable.'**
  String get esimManualSubtitle;

  /// No description provided for @esimSmdpAddress.
  ///
  /// In en, this message translates to:
  /// **'SM-DP+ Address'**
  String get esimSmdpAddress;

  /// No description provided for @esimActivationCode.
  ///
  /// In en, this message translates to:
  /// **'Activation Code'**
  String get esimActivationCode;

  /// No description provided for @esimConfirmationCode.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Code'**
  String get esimConfirmationCode;

  /// No description provided for @esimConfirmationOptional.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Code: leave empty unless your carrier provided one.'**
  String get esimConfirmationOptional;

  /// No description provided for @esimStepsIphoneTitle.
  ///
  /// In en, this message translates to:
  /// **'iPhone steps'**
  String get esimStepsIphoneTitle;

  /// No description provided for @esimStepIphone1.
  ///
  /// In en, this message translates to:
  /// **'Settings → Cellular → Add eSIM'**
  String get esimStepIphone1;

  /// No description provided for @esimStepIphone2.
  ///
  /// In en, this message translates to:
  /// **'Use QR Code, or Enter Details Manually'**
  String get esimStepIphone2;

  /// No description provided for @esimStepIphone3.
  ///
  /// In en, this message translates to:
  /// **'Paste SM-DP+ Address and Activation Code'**
  String get esimStepIphone3;

  /// No description provided for @esimStepIphone4.
  ///
  /// In en, this message translates to:
  /// **'Enable Data Roaming for this eSIM when you arrive'**
  String get esimStepIphone4;

  /// No description provided for @esimStepsAndroidTitle.
  ///
  /// In en, this message translates to:
  /// **'Android steps'**
  String get esimStepsAndroidTitle;

  /// No description provided for @esimStepAndroid1.
  ///
  /// In en, this message translates to:
  /// **'Settings → Network & internet → SIMs'**
  String get esimStepAndroid1;

  /// No description provided for @esimStepAndroid2.
  ///
  /// In en, this message translates to:
  /// **'Download a SIM / Add eSIM'**
  String get esimStepAndroid2;

  /// No description provided for @esimStepAndroid3.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code above'**
  String get esimStepAndroid3;

  /// No description provided for @esimStepAndroid4.
  ///
  /// In en, this message translates to:
  /// **'Enable Mobile data + Roaming for this eSIM'**
  String get esimStepAndroid4;

  /// No description provided for @esimApnHint.
  ///
  /// In en, this message translates to:
  /// **'If needed, set APN to: {apn}'**
  String esimApnHint(String apn);

  /// No description provided for @esimRoamingHint.
  ///
  /// In en, this message translates to:
  /// **'After install: turn on Data Roaming and select this eSIM for Mobile Data.'**
  String get esimRoamingHint;

  /// No description provided for @esimOpenShareLink.
  ///
  /// In en, this message translates to:
  /// **'Open install page'**
  String get esimOpenShareLink;

  /// No description provided for @esimShareCode.
  ///
  /// In en, this message translates to:
  /// **'Access code: {code}'**
  String esimShareCode(String code);

  /// No description provided for @esimOpenLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get esimOpenLinkFailed;

  /// No description provided for @orderHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get orderHistoryTitle;

  /// No description provided for @orderHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get orderHistoryEmpty;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Processing payment'**
  String get orderStatusPaid;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Preparing eSIM'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get orderStatusFailed;

  /// No description provided for @completePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete payment'**
  String get completePayment;

  /// No description provided for @orderAwaitingVerification.
  ///
  /// In en, this message translates to:
  /// **'Awaiting verification'**
  String get orderAwaitingVerification;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyTitle;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get supportTitle;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get helpSupport;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get contactEmail;

  /// No description provided for @contactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contactWhatsapp;

  /// No description provided for @supportContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get supportContactTitle;

  /// No description provided for @supportFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Common questions'**
  String get supportFaqTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Travel connected, anywhere'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Browse eSIM data plans for 200+ countries. Instant digital delivery — no physical SIM card needed.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Install in minutes'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code on Android or use one-tap install on iPhone. Your plan activates when you connect abroad.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Pay securely'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Pay with FIB in Iraqi Dinar or by card with Stripe. Your eSIM appears in My eSIMs after payment.'**
  String get onboardingSlide3Body;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get offlineTitle;

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get offlineMessage;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @esimLowDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Low data remaining'**
  String get esimLowDataTitle;

  /// No description provided for @esimLowDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Only {percent}% of your data is left. Consider topping up before you run out.'**
  String esimLowDataMessage(int percent);

  /// No description provided for @esimExpirySoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan expiring soon'**
  String get esimExpirySoonTitle;

  /// No description provided for @esimExpirySoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Your plan expires in {days} days. Renew before you travel again.'**
  String esimExpirySoonMessage(int days);

  /// No description provided for @shareReceipt.
  ///
  /// In en, this message translates to:
  /// **'Share receipt'**
  String get shareReceipt;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'eSIM KRD Receipt'**
  String get receiptTitle;

  /// No description provided for @promoCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get promoCodeLabel;

  /// No description provided for @promoCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get promoCodeHint;

  /// No description provided for @promoApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get promoApply;

  /// No description provided for @promoDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get promoDiscount;

  /// No description provided for @topUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Add more data'**
  String get topUpTitle;

  /// No description provided for @topUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Renew or top up this eSIM with a new package.'**
  String get topUpSubtitle;

  /// No description provided for @topUpAction.
  ///
  /// In en, this message translates to:
  /// **'Top up / renew'**
  String get topUpAction;

  /// No description provided for @referralTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get referralTitle;

  /// No description provided for @referralSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your code. Friends get a great deal and you grow the community.'**
  String get referralSubtitle;

  /// No description provided for @referralShare.
  ///
  /// In en, this message translates to:
  /// **'Share invite link'**
  String get referralShare;

  /// No description provided for @referralShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Get travel eSIM with eSIM KRD! Use my code: {code}'**
  String referralShareMessage(String code);

  /// No description provided for @referralCount.
  ///
  /// In en, this message translates to:
  /// **'{count} friends joined'**
  String referralCount(int count);

  /// No description provided for @currencyDisplay.
  ///
  /// In en, this message translates to:
  /// **'Currency display'**
  String get currencyDisplay;

  /// No description provided for @currencyBoth.
  ///
  /// In en, this message translates to:
  /// **'USD + IQD'**
  String get currencyBoth;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'USD only'**
  String get currencyUsd;

  /// No description provided for @currencyIqd.
  ///
  /// In en, this message translates to:
  /// **'IQD only'**
  String get currencyIqd;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ku'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ku':
      return AppLocalizationsKu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
