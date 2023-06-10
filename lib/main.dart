import 'package:ascoop/firebase_options.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_notification_data_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_wallet_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/loan_payment_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/profile_pic.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/reset_password_status.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/send_verificationcode.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_update_profile_info.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/loan_view.dart';
import 'package:ascoop/services/notification_config.dart';
import 'package:ascoop/web_ui/web_dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ascoop/mobile_ui/emailverification_view.dart';
import 'package:ascoop/mobile_ui/loginoption_view.dart';
import 'package:ascoop/mobile_ui/login_view.dart';
import 'package:ascoop/mobile_ui/register_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//**************************************************************************************************************************** */

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  if (message.notification != null) {
    //No need for showing Notification manually.
    //For BackgroundMessages: Firebase automatically sends a Notification.
    //If you call the flutterLocalNotificationsPlugin.show()-Methode for
    //example the Notification will be displayed twice.
  }
  return;
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
//Create a [IOSNotificationChannel] for heads up notifications

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  AppleNotification? ios = message.notification?.apple;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  } else if (notification != null && ios != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(iOS: DarwinNotificationDetails()),
    );
  }
}
//------ If this doesn't work we can use notification_config at lib/services/notification_config.dart

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//**************************************************************************************************************************** */
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    // TODO: If necessary send token to application server.

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
    if (AuthService.firebase().currentUser != null) {
      await DataService.database().updateFCMToken(token: fcmToken);
    }
  }).onError((err) {
    // Error getting token.
  });

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

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // showFlutterNotification(message);
    NotificationApi.showNotification(
        title: message.notification!.title, body: message.notification!.body);
    // print('Got a message whilst in the foreground!');
    // print('Message data: ${message.data}');

    // if (message.notification != null) {
    //   print(
    //       'Message also contained a notification: ${message.notification!.title}');
    // }
  });
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const _HomeView(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/loginoption/': (context) => const LoginOption(),
      '/dashboard/': (context) => const Dashboard(),
      '/homeview/': (context) => const _HomeView(),
      '/coop/loanview/': (context) => const LoanView(),
      '/coop/loantenureview': (context) => const LoanTenureView(),
      '/user/notificationview/': (context) => const DashboardNotifDataView(),
      '/user/profileinfo/': (context) => const DashboardProfileInfo(),
      '/user/profilepicset/': (context) => const ProfilePicSet(),
      '/user/sendverifCode/': (context) => const SendVFCode(),
      '/user/resetpassawordstatus': (context) => const ResetPasswordStat(),
      '/user/wallet/': (context) => const DashboardWallet()
    },
  ));
}

class _HomeView extends StatefulWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // String? _token;
  String? initialMessage;
  // bool _resolved = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              // _resolved = true;
              initialMessage = value?.data.toString();
            },
          ),
        );

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   // Navigator.pushNamed(
    //   //   context,
    //   //   '/message',
    //   //   arguments: MessageArguments(message, true),
    //   // );
    // });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isDesktop = (defaultTargetPlatform == TargetPlatform.linux ||
    //     defaultTargetPlatform == TargetPlatform.macOS ||
    //     defaultTargetPlatform == TargetPlatform.windows);
    bool isMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
    return isMobile ? mobileUI() : desktopUI();
  }

  void sendFCMtoken() async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      await DataService.database().checkFCMToken(token: token);
    }
  }

  Widget mobileUI() => FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                FlutterNativeSplash.remove();
                if (user.isEmailVerified) {
                  //for user notification ID
                  sendFCMtoken();

                  //for splash to remove

                  if (!kIsWeb) {
                    //for mobile web
                    return const Dashboard();
                  } else {
                    return const WebLoginView();
                  }
                } else {
                  FlutterNativeSplash.remove();
                  devtools.log('this.is dev tools ${user.toString()}');
                  return const EmailVerification();
                }
              } else {
                FlutterNativeSplash.remove();
                return const LoginOption();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      );

  Widget desktopUI() => FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                //for splash to remove
                FlutterNativeSplash.remove();
                if (user.isEmailVerified) {
                  sendFCMtoken();

                  return const WebLoginView();
                } else {
                  return const WebLoginView();
                }
              } else {
                //for splash to remove
                FlutterNativeSplash.remove();
                return const WebLoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      );
}
