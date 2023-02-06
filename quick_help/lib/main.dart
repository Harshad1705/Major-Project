// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quick_help/Officer/navigation_officer.dart';
import 'package:quick_help/Officer/start_page_officer.dart';

import 'Officer/home_page_officer.dart';
import 'Officer/registration_officer.dart';
// import 'Officer/start_page_officer.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // SharedPrefs.prefs = await SharedPreferences.getInstance();
  // SharedPrefs.prefKeys = await SharedPreferences.getInstance();
  // List<String> keys = await SharedPrefs.getKeys();
  // TextData.addedPreferences = await SharedPrefs.getPreferences(keys);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InitializerWidget()
    );
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  DocumentReference<Map<String, dynamic>>? officers;
  FirebaseAuth? _auth;
  User? _user;
  bool isLoading = true;
  bool hasFirestoreData = false;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth?.currentUser;
    officers = FirebaseFirestore.instance.collection('officers').doc(_user?.phoneNumber.toString().replaceAll("+91", ""));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ) : _user != null? officers != null? const Navigation(): RegistrationOfficer(mobile: _user?.phoneNumber.toString() as String):const StartPageOfficer();
  }
}
// class HomePageOfficer extends StatefulWidget {
//   const HomePageOfficer({Key? key}) : super(key: key);
//
//   @override
//   State<HomePageOfficer> createState() => _HomePageOfficerState();
// }
//
// class _HomePageOfficerState extends State<HomePageOfficer> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ));
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         showDialog(
//             context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text(notification.title!),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [Text(notification.body!)],
//                   ),
//                 ),
//               );
//             });
//       }
//     });
//   }
//   void showNotification() {
//
//     flutterLocalNotificationsPlugin.show(
//         0,
//         "Testing",
//         "How you doin ?",
//         NotificationDetails(
//             android: AndroidNotificationDetails(channel.id, channel.name,
//                 channelDescription: channel.description,
//                 importance: Importance.high,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher')));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Container(), floatingActionButton: FloatingActionButton(onPressed: ()=>showNotification(),),);
//   }
// }