// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:monarch_mart/address/address.dart';
import 'package:monarch_mart/address/address_provider.dart';
import 'package:monarch_mart/all_offer/all_offer_provider.dart';
import 'package:monarch_mart/all_offer/all_offers.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/global_variable.dart';
import 'package:monarch_mart/cart/cart.dart';
import 'package:monarch_mart/cart/cart_provider.dart';
import 'package:monarch_mart/cart/checkout/bkash/bkash_provider.dart';
import 'package:monarch_mart/cart/checkout/checkout.dart';
import 'package:monarch_mart/cart/checkout/checkout_provider.dart';
import 'package:monarch_mart/cart/checkout/nagad/nagad.dart';
import 'package:monarch_mart/cart/checkout/nagad/nagad_provider.dart';
import 'package:monarch_mart/cart/checkout/ssl_commerz/ssl_commerz.dart';
import 'package:monarch_mart/cart/checkout/ssl_commerz/ssl_commerz_provider.dart';
import 'package:monarch_mart/cart/checkout/ucb/ucb_provider.dart';
import 'package:monarch_mart/cart/checkout/upay/upay.dart';
import 'package:monarch_mart/cart/checkout/upay/upay_provider.dart';
import 'package:monarch_mart/categories/category.dart';
import 'package:monarch_mart/categories/category_provider.dart';
import 'package:monarch_mart/common_webview/common_webview.dart';
import 'package:monarch_mart/filtered_products/filter_provider.dart';
import 'package:monarch_mart/filtered_products/filtered_product.dart';
import 'package:monarch_mart/forget_password/forget_password.dart';
import 'package:monarch_mart/forget_password/forget_password_provider.dart';
import 'package:monarch_mart/home/home.dart';
import 'package:monarch_mart/home/home_provider.dart';
import 'package:monarch_mart/login/login.dart';
import 'package:monarch_mart/login/login_provider.dart';
import 'package:monarch_mart/orders/order.dart';
import 'package:monarch_mart/orders/order_details/order_details.dart';
import 'package:monarch_mart/orders/order_details/order_details_provider.dart';
import 'package:monarch_mart/orders/order_provider.dart';
import 'package:monarch_mart/otp/otp.dart';
import 'package:monarch_mart/otp/otp_provider.dart';
import 'package:monarch_mart/policy/policy.dart';
import 'package:monarch_mart/policy/policy_provider.dart';
import 'package:monarch_mart/product/product.dart';
import 'package:monarch_mart/product/product_details/product_details.dart';
import 'package:monarch_mart/product/product_details/product_details_provider.dart';
import 'package:monarch_mart/product/product_provider.dart';
import 'package:monarch_mart/product_review/product_review.dart';
import 'package:monarch_mart/product_review/product_review_provider.dart';
import 'package:monarch_mart/product_review/product_reviews.dart';
import 'package:monarch_mart/profile/payment_info/payment.dart';
import 'package:monarch_mart/profile/payment_info/payment_provider.dart';
import 'package:monarch_mart/profile/profile.dart';
import 'package:monarch_mart/profile/profile_edit/ProfileEditProvider.dart';
import 'package:monarch_mart/profile/profile_edit/profile_edit.dart';
import 'package:monarch_mart/profile/profile_provider.dart';
import 'package:monarch_mart/registration/registration.dart';
import 'package:monarch_mart/registration/registration_provider.dart';
import 'package:monarch_mart/reset_password/reset_pass_provider.dart';
import 'package:monarch_mart/reset_password/reset_password.dart';
import 'package:monarch_mart/seller_details/seller_details.dart';
import 'package:monarch_mart/seller_details/seller_details_provider.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:monarch_mart/top_sellers/top_seller.dart';
import 'package:monarch_mart/top_sellers/top_seller_provider.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_components/app_constant.dart';
import 'app_components/app_font.dart';
import 'cart/checkout/bkash/bkash.dart';
import 'cart/checkout/ucb/ucb.dart';
import 'controllers/loader_controller.dart';
import 'myHttpOverrides.dart';
import 'notification_service/Payload.dart';
import 'notification_service/local_notification_service.dart';
import 'splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tokenController = Get.put(LoaderController());
  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  if (Platform.isAndroid) WebView.platform = AndroidWebView();
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
    LocalNotificationService.initialize();
    tokenController.getToken();
    tokenController.refreshToken();
  }
  HttpOverrides.global = MyHttpOverrides();
  runApp(GetMaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

Future<void> backgroundHandler(RemoteMessage? message) async {
  if (message != null) {
    Payload payload = Payload.fromJson(message.data);
    // LocalNotificationService.createNotification(message, payload);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppConstant.TYPE, payload.type!);
    preferences.setString(AppConstant.CLICK_OPTION, payload.clickAction!);
    print('backgroundHandler: ${message.notification!.title}');
  }
}

checkAppVersionUpdate(context) async {
  final newVersion = NewVersion();
  newVersion.showAlertIfNecessary(context: context);
  final status = await newVersion.getVersionStatus();
  log('status ver: ${status!.localVersion} : ${status.storeVersion}');
  // if (status != null && status.canUpdate) {
  //   log('status: ${status.canUpdate}');
  //   log('status ver: ${status.localVersion} : ${status.storeVersion}');
  //   log('status appStoreLink: ${status.appStoreLink}');
  //   newVersion.showUpdateDialog(
  //     context: context,
  //     versionStatus: status,
  //     dialogTitle: 'Custom dialog title',
  //     dialogText: 'Custom dialog text',
  //     updateButtonText: 'Custom update button text',
  //     dismissButtonText: 'Custom dismiss button text',
  //     dismissAction: () => Get.back(),
  //   );
  // }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      checkAppVersionUpdate(context);
      //this method is called when the apps is completely closed
      pushNotificationSettings();
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        clickOption().then((value) {
          clear();
          String type = value[0], url = value[1];

          if (type == "deals" || type == "customer") {
            handleNotificationClick(type: type, url: url);
          } else {}
        });

        if (message != null) {
          Payload payload = Payload.fromJson(message.data);
          LocalNotificationService.createNotification(message, payload);
        }
      });

      //this method is called when the apps is open and user using it
      FirebaseMessaging.onMessage.listen((message) {
        print(message.data);
        if (message != null) {
          Payload payload = Payload.fromJson(message.data);
          LocalNotificationService.createNotification(message, payload);
        }
      });

      //this method is called when the apps is minimized and but open in background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        if (message != null) {
          Payload payload = Payload.fromJson(message.data);
          // LocalNotificationService.createNotification(message, payload);
          print('onMessageOpenedApp onclick: ${message.notification!.title}');
          if (payload.type == "deals") {
            Navigator.pushNamed(
                GlobalVariable.navState.currentContext!, AppRoute.product,
                arguments: ScreenArguments(data: {
                  "url": payload.clickAction.toString(),
                  "category": "Offers",
                  "numberofChildren": 0,
                  "subcategoryUrl": ""
                }));
          } else {
            Navigator.pushNamed(
                GlobalVariable.navState.currentContext!, AppRoute.order);
          }
        }
      });
    } else {}
  }

  pushNotificationSettings() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppConstant.CLICK_OPTION, "");
    preferences.setString(AppConstant.TYPE, "");
  }

  Future<List<String>> clickOption() async {
    List<String> mylists = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    mylists.add(preferences.getString(AppConstant.TYPE).toString());
    mylists.add(preferences.getString(AppConstant.CLICK_OPTION).toString());

    return mylists;
  }

  void handleNotificationClick({required String url, required String type}) {
    if (type == "deals") {
      Navigator.pushNamed(context, AppRoute.product,
          arguments: ScreenArguments(data: {
            "url": url,
            "category": "Offers",
            "numberofChildren": 0,
            "subcategoryUrl": ""
          }));
    } else {
      Navigator.pushNamed(context, AppRoute.order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppProvider()),
        ],
        child: ScreenUtilInit(
          designSize: Size(428, 926),
          minTextAdapt: true,
          builder: (BuildContext c) => MaterialApp(
            theme: ThemeData(fontFamily: AppFont.Poppins),
            navigatorKey: GlobalVariable.navState,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoute.splash_screen,
            routes: {AppRoute.splash_screen: (context) => SplashScreen()},
            onGenerateRoute: (settings) {
              ScreenArguments? args = settings.arguments != null
                  ? settings.arguments as ScreenArguments
                  : null;
              switch (settings.name) {
                case AppRoute.home:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                        create: (context) => HomeProvider(),
                        child: Home(),
                      ),
                      time: 10,
                      transition: 0);

                case AppRoute.cart:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => CartProvider(), child: Cart()),
                      time: 10,
                      transition: 0);
                case AppRoute.category:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => CategoryProvider(),
                          child: Category(url: args!.data!["url"].toString())),
                      time: 10,
                      transition: 0);
                case AppRoute.address:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                        create: (context) => AddressProvider(),
                        child: args == null
                            ? Address()
                            : Address(
                                ownerId: args.data!["ownerId"].toString(),
                                isFromCart: true,
                              ),
                      ));

                case AppRoute.profile:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ProfileProvider(),
                          child: Profile()),
                      time: 10,
                      transition: 0);

                case AppRoute.profileEdit:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ProfileEditProvider(),
                          child: ProfileEdit()));

                case AppRoute.paymentInfo:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => PaymentProvider(),
                          child: Payment()));

                case AppRoute.webview:
                  return routeBuilder(
                      settings,
                      CommonWebView(
                          url: args!.data!["url"].toString(),
                          title: args.data!["title"].toString()));

                case AppRoute.login:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                        create: (context) => LoginProvider(),
                        child: Login(),
                      ));
                case AppRoute.registration:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => RegistrationProvider(),
                          child: Registration()));

                case AppRoute.orderDetails:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => OrderDetailsProvider(),
                          child: OrderDetails(
                              orderId: args!.data!["orderId"].toString())));
                case AppRoute.order:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => OrderProvider(),
                          child: Order()));
                case AppRoute.checkout:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => CheckoutProvider(),
                          child: Checkout(
                              ownerId: args!.data!["ownerId"].toString())));

                case AppRoute.bkash:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => BkashProvider(),
                          child: Bkash(
                            ownerId: args!.data!["ownerId"].toString(),
                            orderId: args.data!["orderId"].toString(),
                            amount: args.data!["amount"].toString(),
                            paymentMethodKey:
                                args.data!["methodkey"].toString(),
                            paymentType: args.data!["paymentType"].toString(),
                          )));

                case AppRoute.nagad:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => NagadProvider(),
                          child: Nagad(
                            ownerId: args!.data!["ownerId"].toString(),
                            orderId: args.data!["orderId"].toString(),
                            amount: args.data!["amount"].toString(),
                            paymentMethodKey:
                                args.data!["methodkey"].toString(),
                            paymentType: args.data!["paymentType"].toString(),
                          )));
                case AppRoute.upay:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => UpayProvider(),
                          child: Upay(
                            ownerId: args!.data!["ownerId"].toString(),
                            orderId: args.data!["orderId"].toString(),
                            amount: args.data!["amount"].toString(),
                            paymentMethodKey:
                                args.data!["methodkey"].toString(),
                            paymentType: args.data!["paymentType"].toString(),
                          )));
                case AppRoute.ucb:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => UcbProvider(),
                          child: Ucb(
                            ownerId: args!.data!["ownerId"].toString(),
                            orderId: args.data!["orderId"].toString(),
                            amount: args.data!["amount"].toString(),
                            paymentMethodKey:
                                args.data!["methodkey"].toString(),
                            paymentType: args.data!["paymentType"].toString(),
                          )));
                case AppRoute.sslCommerz:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => SSlCommerzProvider(),
                          child: SSlCommerz(
                            ownerId: args!.data!["ownerId"].toString(),
                            orderId: args.data!["orderId"].toString(),
                            amount: args.data!["amount"].toString(),
                            paymentMethodKey:
                                args.data!["methodkey"].toString(),
                            paymentType: args.data!["paymentType"].toString(),
                          )));
                case AppRoute.allOffers:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => AllOfferProvider(),
                          child: AllOffer(
                            isNotFromBottomNavigation:
                                args != null ? args.data!["option"] : true,
                          )),
                      time: 10,
                      transition: 0);

                case AppRoute.filteredProduct:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                        create: (context) => FilterProvider(),
                        child: FilteredProduct(
                            currentCategory:
                                args?.data?["category"].toString() ?? ""),
                      ));

                case AppRoute.seller_details:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                        create: (context) => SellerDetailsProvider(),
                        child: SellerDetails(
                            sellerId: args?.data?["sellerId"].toString() ?? ""),
                      ));

                case AppRoute.topSellers:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => TopSellerProvider(),
                          child: TopSellers()));

                case AppRoute.product:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ProductProvider(),
                          child: Product(
                            url: args!.data!["url"].toString(),
                            categoryName: args.data!["category"].toString(),
                            numberOfChildren: args.data!["numberofChildren"],
                            subcategoryUrl:
                                args.data!["subcategoryUrl"].toString(),
                          )));

                case AppRoute.otp:
                  return routeBuilder(
                    settings,
                    ChangeNotifierProvider(
                      create: (context) => OtpProvider(),
                      child: Otp(
                          registrationMethod: args?.data?["method"] ?? "",
                          emailorPhone: args?.data?["emailOrphone"] ?? "",
                          userId: args?.data?["userId"] ?? ""),
                    ),
                  );

                case AppRoute.product_details:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ProductDetailsProvider(),
                          child: ProductDetails(
                              productId: args?.data?["productId"] ?? "")));

                case AppRoute.review:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ProductReviewProvider(),
                          child: ProductReviews(
                              productId: args!.data!["productId"].toString())));

                case AppRoute.reviewtwo:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ProductReviewProvider(),
                          child: ProductReviewss(
                              productId: args!.data!["productId"].toString())));

                case AppRoute.forgetpass:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ForgetPasswordProvider(),
                          child: ForgetPassword()));
                case AppRoute.resetPass:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => ResetPasswordProvider(),
                          child: ResetPassword()));
                case AppRoute.policy:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                          create: (context) => PolicyProvider(),
                          child: Policy(
                              headingTitle: args?.data?["title"] ?? "",
                              policyType: args?.data?["type"] ?? "")));

                default:
                  return routeBuilder(
                      settings,
                      ChangeNotifierProvider(
                        create: (context) => HomeProvider(),
                        child: Home(),
                      ));
              }
            },
          ),
        ));
  }

  PageRouteBuilder routeBuilder(RouteSettings settings, Widget screen,
      {double? transition, int? time}) {
    return PageRouteBuilder(
        opaque: true,
        transitionDuration: Duration(
          milliseconds: time ?? 50,
        ),
        pageBuilder: (BuildContext context, _, __) {
          return screen;
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new SlideTransition(
            child: child,
            position: new Tween<Offset>(
              begin: Offset(transition ?? 1, 0),
              end: Offset.zero,
            ).animate(animation),
          );
        });
  }
}
