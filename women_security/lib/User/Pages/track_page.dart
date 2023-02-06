// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:women_security/Pages/Navigation%20Pages/map_page.dart';
// import 'package:women_security/Pages/navigation.dart';
//
// class TrackPage extends StatefulWidget {
//   const TrackPage({Key? key}) : super(key: key);
//
//   @override
//   State<TrackPage> createState() => _TrackPageState();
// }
//
// class _TrackPageState extends State<TrackPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//               margin: EdgeInsets.only(left: 20,top: 200),
//               child: MapPage().h(400).w(370),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 160,top: 700),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50)
//                 )
//               ),
//               onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Navigation()));},
//             child: Text("  Cancel  "),),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
// // const kTileHeight = 50.0;
// //
// // const completeColor = Color(0xff5ec792);
// // const inProgressColor = Color(0xfffecc00);
// // const todoColor = Color(0xfffb0000);
//
// // int _processIndex = 2;
// // Color getColor(int index) {
// //   if (index == _processIndex) {
// //     return inProgressColor;
// //   } else if (index < _processIndex) {
// //     return completeColor;
// //   } else {
// //     return todoColor;
// //   }
// // }
//
// // /// hardcoded bezier painter
// // /// TODO: Bezier curve into package component
// // class _BezierPainter extends CustomPainter {
// //   const _BezierPainter({
// //     required this.color,
// //     this.drawStart = true,
// //     this.drawEnd = true,
// //   });
// //
// //   final Color color;
// //   final bool drawStart;
// //   final bool drawEnd;
// //
// //   Offset _offset(double radius, double angle) {
// //     return Offset(
// //       radius * cos(angle) + radius,
// //       radius * sin(angle) + radius,
// //     );
// //   }
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..style = PaintingStyle.fill
// //       ..color = color;
// //
// //     final radius = size.width / 2;
// //
// //     var angle;
// //     var offset1;
// //     var offset2;
// //
// //     var path;
// //
// //     if (drawStart) {
// //       angle = 3 * pi / 4;
// //       offset1 = _offset(radius, angle);
// //       offset2 = _offset(radius, -angle);
// //       path = Path()
// //         ..moveTo(offset1.dx, offset1.dy)
// //         ..quadraticBezierTo(0.0, size.height / 2, -radius,
// //             radius) // TODO connector start & gradient
// //         ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
// //         ..close();
// //
// //       canvas.drawPath(path, paint);
// //     }
// //     if (drawEnd) {
// //       angle = -pi / 4;
// //       offset1 = _offset(radius, angle);
// //       offset2 = _offset(radius, -angle);
// //
// //       path = Path()
// //         ..moveTo(offset1.dx, offset1.dy)
// //         ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
// //             radius) // TODO connector end & gradient
// //         ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
// //         ..close();
// //
// //       canvas.drawPath(path, paint);
// //     }
// //   }
// //
// //   @override
// //   bool shouldRepaint(_BezierPainter oldDelegate) {
// //     return oldDelegate.color != color ||
// //         oldDelegate.drawStart != drawStart ||
// //         oldDelegate.drawEnd != drawEnd;
// //   }
// // }
//
// // final _processes = [
// //   'Help',
// //   'Sms',
// //   'Location',
// //   'Officer',
// //   'Done',
// // ];
// //
// // final _tracks = [
// //   'Getting',
// //   'Sending',
// //   'Sending',
// //   'Assigning',
// //   'Track',
// // ];
//
// // Container(
// // height: context.screenHeight/6,
// // width: context.screenWidth/1.04,
// // margin: EdgeInsets.only(top: 50),
// // decoration:  BoxDecoration(
// // borderRadius: BorderRadius.circular(20),
// // gradient: const LinearGradient(
// // begin: Alignment.topLeft,
// // end: Alignment.bottomRight,
// // colors: [
// // Color(0xffF0FCFD),
// // Color(0xffEAF0FF),
// // Color(0xffF9F2FF),
// // Colors.white
// // ],
// // transform: GradientRotation(45)),
// // boxShadow: [
// // BoxShadow(
// // offset: const Offset(-10, -10),
// // color: const Color(0xffEAEFFF),
// // blurRadius: 10,
// //
// // ),
// // BoxShadow(
// // offset: const Offset(10, 10),
// // color: const Color(0xffC2CCEB),
// // blurRadius: 10,
// // )
// // ],
// // ),
// // child: Timeline.tileBuilder(
// // theme: TimelineThemeData(
// // direction: Axis.horizontal,
// // connectorTheme: ConnectorThemeData(
// // space: 30.0,
// // thickness: 5.0,
// // ),
// // ),
// // builder: TimelineTileBuilder.connected(
// // connectionDirection: ConnectionDirection.before,
// // itemExtentBuilder: (_, __) =>
// // MediaQuery.of(context).size.width / _processes.length,
// // oppositeContentsBuilder: (context, index) {
// // return Padding(
// // padding: const EdgeInsets.only(bottom: 15.0),
// // child: Text(_tracks[index])
// // );
// // },
// // contentsBuilder: (context, index) {
// // return Padding(
// // padding: const EdgeInsets.only(top: 15.0),
// // child: Text(
// // _processes[index],
// // style: TextStyle(
// // fontWeight: FontWeight.bold,
// // color: getColor(index),
// // ),
// // ),
// // );
// // },
// // indicatorBuilder: (_, index) {
// // var color;
// // var child;
// // if (index == _processIndex) {
// // color = inProgressColor;
// // child = Padding(
// // padding: const EdgeInsets.all(8.0),
// // child: CircularProgressIndicator(
// // strokeWidth: 3.0,
// // valueColor: AlwaysStoppedAnimation(Colors.white),
// // ),
// // );
// // } else if (index < _processIndex) {
// // color = completeColor;
// // child = Icon(
// // Icons.check,
// // color: Colors.white,
// // size: 15.0,
// // );
// // } else {
// // color = todoColor;
// // }
// //
// // if (index <= _processIndex) {
// // return Stack(
// // children: [
// // CustomPaint(
// // size: Size(30.0, 30.0),
// // painter: _BezierPainter(
// // color: color,
// // drawStart: index > 0,
// // drawEnd: index < _processIndex,
// // ),
// // ),
// // DotIndicator(
// // size: 30.0,
// // color: color,
// // child: child,
// // ),
// // ],
// // );
// // } else {
// // return Stack(
// // children: [
// // CustomPaint(
// // size: Size(15.0, 15.0),
// // painter: _BezierPainter(
// // color: color,
// // drawEnd: index < _processes.length - 1,
// // ),
// // ),
// // OutlinedDotIndicator(
// // borderWidth: 4.0,
// // color: color,
// // ),
// // ],
// // );
// // }
// // },
// // connectorBuilder: (_, index, type) {
// // if (index > 0) {
// // if (index == _processIndex) {
// // final prevColor = getColor(index - 1);
// // final color = getColor(index);
// // List<Color> gradientColors;
// // if (type == ConnectorType.start) {
// // gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
// // } else {
// // gradientColors = [
// // prevColor,
// // Color.lerp(prevColor, color, 0.5)!
// // ];
// // }
// // return DecoratedLineConnector(
// // decoration: BoxDecoration(
// // gradient: LinearGradient(
// // colors: gradientColors,
// // ),
// // ),
// // );
// // } else {
// // return SolidLineConnector(
// // color: getColor(index),
// // );
// // }
// // } else {
// // return null;
// // }
// // },
// // itemCount: _processes.length,
// // ),
// // ),
// // ).p(5),