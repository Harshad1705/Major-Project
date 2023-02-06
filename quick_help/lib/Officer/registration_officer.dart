import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_help/Officer/home_page_officer.dart';
import 'package:quick_help/Officer/navigation_officer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Utils/text_data.dart';

class RegistrationOfficer extends StatefulWidget {
  final String mobile;
  const RegistrationOfficer({Key? key, required this.mobile}) : super(key: key);

  @override
  State<RegistrationOfficer> createState() => _RegistrationOfficerState();
}

class _RegistrationOfficerState extends State<RegistrationOfficer> {
  final users = FirebaseFirestore.instance.collection('officers');
  final CarouselController controller = CarouselController();
  // ignore: prefer_typing_uninitialized_variables
  var jsn;
  // String? selectedCity;
  List<String> cities = [];
  bool isGetJsonDone = false;
  bool prevTapped = false;
  bool nextTapped = false;
  bool isLast = false;
  double _originLatitude = 0.0;
  double _originLongitude = 0.0;
  String name = "";
  String email = "";
  String state = "";
  String city = "";
  @override
  void initState() {
    _determinePosition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Offset distanceN = nextTapped ? const Offset(5, 5) : const Offset(14, 14);
    double blurN = nextTapped ? 5.0 : 30.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: context.screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
                Colors.white
              ],
              transform: GradientRotation(45)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 5,
            ),
            Text(
              "Registration",
              style: GoogleFonts.poppins(
                  fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
            ),
            const Spacer(
              flex: 2,
            ),
            // getCard(regPages),
            getRegPage(),
            const Spacer(
              flex: 3,
            ),
            // getPrevNext(distanceP,distanceN,blurP,blurN),
            getOnlyNext(distanceN, blurN),
            const Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }
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
  getOnlyNext(var distanceN, var blurN) {
    return Listener(
      onPointerUp: (_) => setState(() => nextTapped = false),
      onPointerDown: (_) => setState(() => nextTapped = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: context.screenHeight / 12,
        width: context.screenHeight / 3,
        decoration: BoxDecoration(
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
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: -distanceN,
                color: const Color(0xffEAEFFF),
                blurRadius: blurN,
              ),
              BoxShadow(
                offset: distanceN,
                color: const Color(0xffC2CCEB),
                blurRadius: blurN,
              )
            ]),
        child: Center(
          child: Text(
            "NEXT",
            style: GoogleFonts.poppins(
                fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
          ),
        ),
      ).onTap(() {
        addUser();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Navigation(),fullscreenDialog: true));
      }),
    );
  }
  Future<void> addUser() {
    return users
        .doc(widget.mobile)
        .set({
      'full_name': name,
      'State': state,
      'city' : city,
      'email': email,
      'mobile_number': widget.mobile,
      'location': GeoPoint(_originLatitude, _originLongitude),
      'triggered': false,
      'help_seeker' : "",
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  getRegPage() {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: context.screenHeight / 1.5,
      width: context.screenWidth / 1.1,
      decoration: BoxDecoration(
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
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              offset: Offset(-10, -10),
              color: Color(0xffEAEFFF),
              blurRadius: 20,
            ),
            BoxShadow(
              offset: Offset(10, 10),
              color: Color(0xffC2CCEB),
              blurRadius: 20,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getDetailsVertical("Name", TextInputType.name, false),
          getDetailsVertical("Email", TextInputType.emailAddress, false),
          getDetailsVertical("State", TextInputType.text, true),
          getDetailsVertical("City", TextInputType.text, true),
        ],
      ),
    );
  }
  getDetailsVertical(String hint, var type, bool isDropDown) {
    return AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: context.screenHeight / 12,
        width: context.screenHeight / 2.6,
        decoration: BoxDecoration(
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
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                offset: Offset(-5, -5),
                color: Color(0xffEAEFFF),
                blurRadius: 5,
                inset: true,
              ),
              BoxShadow(
                offset: Offset(5, 5),
                color: Color(0xffC2CCEB),
                blurRadius: 5,
                inset: true,
              )
            ]),
        child: Center(
          child: isDropDown
              ? DropdownButtonFormField(
            isDense: true,
            borderRadius: BorderRadius.circular(30),
            menuMaxHeight: context.screenHeight,
            dropdownColor: const Color(0xffEAEFFF),
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 50, right: 20),
              isDense: true,
            ),
            hint: Center(
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
            ),
            iconSize: 30,
            onChanged: (selectedState) {
              setState(() => {
                if (hint == "State")
                  {
                    getJson(selectedState.toString()),
                    state = selectedState.toString(),
                  },
                city = selectedState.toString(),
              });
            },
            items: hint == "State"
                ? TextData.states
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: context.screenHeight / 12,
                  width: context.screenHeight / 2.6,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                        item.replaceAll("*", ""),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                        ),
                      ))),
            ))
                .toList()
                : cities
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: context.screenHeight / 12,
                  width: context.screenHeight / 2.6,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                        item.replaceAll("*", ""),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                        ),
                      ))),
            ))
                .toList(),
          )
              : TextFormField(
            textAlign: TextAlign.center,
            maxLength: 50,
            cursorColor: Colors.red,
            cursorHeight: 20,
            keyboardType: type,
            style: const TextStyle(
              letterSpacing: 1,
              fontSize: 20,
            ),
            onChanged: (value) {
              hint == "Name" ? name = value : email = value;
            },
            decoration: InputDecoration(
              counterText: "",
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ));
  }
  getJson(String selectedState) async {
    if (!isGetJsonDone) {
      var url = Uri.parse(
          "https://raw.githubusercontent.com/bhanuc/indian-list/master/state-city.json");
      var response = await http.get(url);
      var body = response.body;
      var html = parse(body);
      jsn = jsonDecode(html.querySelector("body")!.text.toString());
      setState(() => isGetJsonDone = true);
    }
    var ct = jsn[selectedState.toString()];
    for (int i = 0; i < ct.length; i++) {
      cities.add(ct[i].toString());
    }
  }
}
