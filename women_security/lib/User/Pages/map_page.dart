import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:label_marker/label_marker.dart';
import 'package:women_security/User/Utils/location_service.dart';
import 'package:local_auth/local_auth.dart';
import 'navigation.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final officers = FirebaseFirestore.instance.collection('officers');
  final users = FirebaseFirestore.instance.collection('users');
  final _authUser = FirebaseAuth.instance.currentUser;
  late GoogleMapController mapController;
  final LocalAuthentication auth = LocalAuthentication();
  // ignore: prefer_typing_uninitialized_variables
  var nearestPoliceOfficer;
  // ignore: prefer_typing_uninitialized_variables
  var policeData;
  bool runningInBackground = false;
  PolylinePoints polylinePoints = PolylinePoints();
  double _originLatitude = 22.71757812524816; //indore lat
  double _originLongitude = 75.85886147903362; // indore lng
  String stationDistance = "0.0";
  String reachTime = "0,0";
  Color bestRoute = Colors.lightBlueAccent;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor policeStationIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> textMarker = {};
  Map<PolylineId, Polyline> polyLines = {};
  StreamSubscription<Position>? positionStream;
  bool isPop = false;
  bool verified = false;
  bool isRunning = false;
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final defaultPinTheme = PinTheme(
    width: 60,
    height: 64,
    textStyle: GoogleFonts.poppins(
        fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
    decoration: BoxDecoration(
        color: Colors.blueAccent.shade200,
        borderRadius: BorderRadius.circular(24),
    ),
  );
  final cursor = Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 21,
      height: 1,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(137, 146, 160, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  @override
  void initState() {
    _getPolyline();
    super.initState();
  }
  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
  verify(){
    return Center(
      child: Pinput(
        length: 4,
        controller: controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        separator: const SizedBox(width: 16),
        obscureText: true,
        onCompleted: (value)async{
          if(value == "1234"){
            setState((){
              verified = true;
              context.pop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Navigation()));
            });
          }else{
            const snackBar = SnackBar(content: Text("Wrong pin!"),);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffEAEFFF),
                offset: Offset(0, 3),
                blurRadius: 16,
              )
            ],
          ),
        ),
        showCursor: true,
        cursor: cursor,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'कृपया प्रमाणित करें!',);
        if(didAuthenticate){
          await officers.doc(policeData['mobile_number'].toString()).update({'triggered' : false, 'help_seeker': ""});
          // ignore: use_build_context_synchronously
          context.pop();
          // context.pop();
        }
        return false;
      },
      child: Scaffold(
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            shape: const Border(),
            backgroundColor: Colors.red.shade300,
            child: isRunning? const Text("Stop LU"): const Text("Start LU"),
            onPressed: (){
              setState(() {
                isRunning? isRunning = false: isRunning = true;
              });
              // mapController.animateCamera(
              //   CameraUpdate.newCameraPosition(
              //     CameraPosition(target: LatLng(_originLatitude, _originLongitude),tilt: 90, bearing: -90, zoom: 20)
              //   )
              // );
            },
          ).h(isPop? 0: 50).w(isPop? 0: 100),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                      target: LatLng(_originLatitude, _originLongitude),
                      zoom: 10,
                ),
                myLocationEnabled: true,
                compassEnabled: true,
                indoorViewEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: _onMapCreated,
                markers: textMarker,
                polylines: Set<Polyline>.of(polyLines.values),
                // circles: {Circle(circleId: const CircleId("Circle"), radius: 10, fillColor: Colors.blue, center: LatLng(_originLatitude, _originLongitude))},
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.redAccent.shade200,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text("Time\n$reachTime", style: GoogleFonts.poppins(
                        color: Vx.white,
                      ),).centered(),
                    ),
                    Container(
                      height: 60,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade200,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text("Distance\n$stationDistance",style: GoogleFonts.poppins(
                      color: Vx.white,
                      ),).centered(),
                    ),
                  ],
                ),
              ),
              isPop? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Verify Your Pin", style: GoogleFonts.poppins(color: Vx.black, fontSize: 30, fontWeight: FontWeight.bold)),
                    verify(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent.shade200,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text("Cancel", style: GoogleFonts.poppins(color: Vx.white),).centered(),
                    ).h(50).w(100).onInkTap(()async{
                      setState(() {
                        isPop = false;
                      });
                    },),
                  ],
                ),
              ):const SizedBox(),
            ],
          )),
    );
  }
  _getNearestPolice()async{
    await officers
        .get()
        .then((QuerySnapshot querySnapshot) async{
      double minDistance = double.maxFinite;
      for (var doc in querySnapshot.docs){
        var temp = await LocationService().getDirection(
          _originLatitude,
          _originLongitude,
          doc['location'].latitude,
          doc['location'].longitude,
        );
        print(temp['distance']);
        double currentDistance = double.parse(temp['distance'].toString().replaceAll(" m", "").replaceAll("km", ""));
        bool isKm = temp['distance'].toString().contains("km");
        if(isKm)currentDistance = currentDistance*1000;
        if(currentDistance < minDistance){
          nearestPoliceOfficer = temp;
          minDistance = currentDistance;
          policeData = doc;
        }
      }
    });
  }
  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  _updateFirebaseLocation(){
    return users
        .doc(_authUser?.phoneNumber?.replaceAll("+91", ""))
        .update({'location': GeoPoint(_originLatitude, _originLongitude)})
        .then((value) => print("User Location Updated On Firebase"))
        .catchError((error) => print("Failed to update user Location: $error"));
  }
  _getOfficerLocationUpdate()async{
    final Stream<DocumentSnapshot> documentStream = FirebaseFirestore.instance
        .collection('officers')
        .doc(policeData['mobile_number'].toString())
        .snapshots();
    documentStream.listen((snapshot) async {
      setState(() {
        if (!snapshot.exists) {
          print('Something went wrong');
        }else{
          print("Update!!!!!!");
          _addMarker(
            LatLng(snapshot['location'].latitude, snapshot['location'].longitude),
            "police",
            BitmapDescriptor.defaultMarker,
          );
        }
      });
    });
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
  _getLocationUpdates() {
    const LocationSettings locationSettings =
    LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 0);
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
          setState(() {
            _originLatitude = position?.latitude ?? _originLatitude;
            _originLongitude = position?.longitude ?? _originLongitude;
            _addMarker(
                LatLng(_originLatitude, _originLongitude), "origin", sourceIcon);
            isRunning? _updateFirebaseLocation():null;
          });
        });
  }
  _setCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/police-badge_128px.png')
        .then((icon) {
      setState(() {
        policeStationIcon = icon;
      });
    });
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/sos.png')
        .then((icon) {
      setState(() {
        sourceIcon = icon;
      });
    });
  }
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    textMarker.add(marker);
  }
  _addMarkerText(String text, String markId, LatLng latLng, Color clr) {
    textMarker.addLabelMarker(
      LabelMarker(
        label: text,
        markerId: MarkerId(markId),
        position: latLng,
        backgroundColor: clr,
      ),
    ).then(
      (value) {
        setState(() {});
      },
    );
  }
  _addPolyLine(List<PointLatLng> points, Map<String, dynamic> boundNe, Map<String, dynamic> boundSw, String polyId, Color clr) {
    PolylineId id = PolylineId(polyId);
    Polyline polyline = Polyline(
      zIndex: 0,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      polylineId: id,
      jointType: JointType.round,
      geodesic: true,
      color: clr,
      points: points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
      width: 5,
    );
    polyLines[id] = polyline;
    setState(() {});
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundSw['lat'], boundSw['lng']),
            northeast: LatLng(boundNe['lat'], boundNe['lng']),
          ),
          50),
    );
  }
  _getPolyline() async {
    await _determinePosition();
    _getLocationUpdates();
    await _setCustomMarker();
    // _addMarkerText(
    //     "Start Location",
    //     "StartLocation",
    //     LatLng(
    //       _originLatitude,
    //       _originLongitude,
    //     ),
    //     Colors.red);
    _addMarker(
      LatLng(_originLatitude, _originLongitude),
      "origin",
      sourceIcon,
    );
    // for (int i = 0; i < TextData.policeStationLocations.length; i++) {
    //   _addMarker(
    //     TextData.policeStationLocations[i],
    //     TextData.policeStationNames[i],
    //     policeStationIcon,
    //   );
    // }
    await _getNearestPolice();
    var station = await LocationService().getNearestStation(
      _originLatitude,
      _originLongitude,
    );
    // _addMarkerText(
    //   "Police-Station",
    //   "EndLocation",
    //   LatLng(station['latitude'], station['longitude']),
    //   Colors.greenAccent,
    // );
    _addMarker(
      LatLng(station['latitude'], station['longitude']),
      station['name'],
      policeStationIcon,
    );
    _addMarker(
      LatLng(policeData['location'].latitude, policeData['location'].longitude),
      "police",
      BitmapDescriptor.defaultMarker,
    );
    setState(() {
      stationDistance = nearestPoliceOfficer['distance'];
      reachTime = nearestPoliceOfficer['time'];
    });
    _addPolyLine(
      nearestPoliceOfficer['polyline_decoded'],
      nearestPoliceOfficer['bounds_ne'],
      nearestPoliceOfficer['bounds_sw'],
      "1",
      bestRoute,
    );
    await officers.doc(policeData['mobile_number'].toString()).update({'triggered' : true, 'help_seeker': _authUser?.phoneNumber.toString().replaceAll("+91", "")});
    _getOfficerLocationUpdate();
  }
}
