import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

import 'map_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

class HomePageOfficer extends StatefulWidget {
  const HomePageOfficer({Key? key}) : super(key: key);

  @override
  State<HomePageOfficer> createState() => _HomePageOfficerState();
}
final player = AudioPlayer();
void showNotification() async{
  String alarmAudioPath = "sound_alarm.mp3";
  await player.play(AssetSource(alarmAudioPath), mode: PlayerMode.lowLatency);
  flutterLocalNotificationsPlugin.show(
      0,
      "Testing",
      "Someone need help!",
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher')));
}

class _HomePageOfficerState extends State<HomePageOfficer> {
  double? _originLatitude;
  double? _originLongitude;
  bool isTriggered = false;
  final currentOfficer = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  late final Stream<DocumentSnapshot> documentStream;
  var datas;
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _originLatitude = pos.latitude;
      _originLongitude = pos.longitude;
    });
  }
  getStream()async{
    await _determinePosition();
    await FirebaseFirestore.instance.collection('officers').doc(currentOfficer?.phoneNumber.toString().replaceAll("+91", "")).update({'location': GeoPoint(_originLatitude!, _originLongitude!)});
    documentStream = FirebaseFirestore.instance
        .collection('officers')
        .doc(currentOfficer?.phoneNumber.toString().replaceAll("+91", ""))
        .snapshots();
    documentStream.listen((snapshot) async {
      if (!snapshot.exists) {
        print('Something went wrong');
      }
      final offData = snapshot.data() as Map<String, dynamic>;
      if (offData['triggered']) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(offData['help_seeker'])
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              datas = documentSnapshot.data() as Map<String, dynamic>;
            });
          }
        });
        setState(() {
          isTriggered = true;
        });
        showNotification();
      } else {
        setState(() {
          player.stop();
          isTriggered = false;
        });
      }
    });
  }
  @override
  void initState() {
    getStream();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Offset distanceN = isTriggered ? const Offset(5, 5) : const Offset(10, 10);
    double blurN = isTriggered ? 5.0 : 20.0;
    List<BoxShadow> myShadows = [
      BoxShadow(
        offset: -distanceN,
        color: !isTriggered ? Colors.greenAccent : Colors.redAccent,
        blurRadius: blurN,
      ),
      BoxShadow(
        offset: distanceN,
        color: !isTriggered ? Colors.greenAccent : Colors.redAccent,
        blurRadius: blurN,
      )
    ];
    return Scaffold(
      body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: context.screenWidth,
            decoration: const BoxDecoration(
              // color: Vx.white,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xffF0FCFD),
                  Color(0xffEAF0FF),
                  Color(0xffF9F2FF),
                ],
                // transform: GradientRotation(45)
              ),
            ),
            child: Column(
              children: [
                const Spacer(),
                getSOSButton(myShadows),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  isTriggered
                      ? "Someone in trouble!⚠\nName:${datas['full_name']} Mobile:${datas['mobile_number']} ${datas['location'].latitude}, ${datas['location'].longitude}"
                      : "Everyone is safe!✅",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
    );
  }

  getSOSButton(var myShadows) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.only(top: context.screenHeight * 0.15),
      height: context.screenHeight / 3,
      width: context.screenHeight / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffF0FCFD),
              Color(0xffEAF0FF),
              Color(0xffF9F2FF),
              Colors.white
            ],
            transform: GradientRotation(45)),
        boxShadow: myShadows,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: context.screenHeight / 4,
          width: context.screenHeight / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffF0FCFD),
                  Color(0xffEAF0FF),
                  Color(0xffF9F2FF),
                  Colors.white
                ],
                transform: GradientRotation(45)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(-10, -10),
                color: !isTriggered ? Colors.greenAccent : Colors.redAccent,
                blurRadius: 10,
                inset: isTriggered,
              ),
              BoxShadow(
                offset: const Offset(10, 10),
                color: !isTriggered ? Colors.greenAccent : Colors.redAccent,
                blurRadius: 10,
                inset: isTriggered,
              )
            ],
          ),
          child: Text(
            isTriggered? "Help Me": "Just Chill",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: isTriggered? Colors.redAccent : Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 1,
            ),
          ).centered(),
        ),
      ),
    ).onInkTap(() {
      isTriggered? Navigator.push(context, PageTransition(child: MapPage(helpSeekerData: datas,), type: PageTransitionType.fade)): null;
      player.stop();
    });
  }
}
