import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_security/User/Pages/navigation.dart';
import 'package:women_security/User/Pages/registration.dart';
import 'User/Pages/start_page.dart';
import 'User/Utils/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPrefs.prefs = await SharedPreferences.getInstance();
  SharedPrefs.prefKeys = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: InitializerWidget());
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  DocumentReference<Map<String, dynamic>>? _users;
  FirebaseAuth? _auth;
  User? _user;
  bool isLoading = true;
  bool hasFirestoreData = false;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth?.currentUser;
    _users = FirebaseFirestore.instance
        .collection('users')
        .doc(_user?.phoneNumber?.replaceAll("+91", ""));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user != null
            ? _users != null
                ? const Navigation()
                : Registration(mobile: _user?.phoneNumber.toString() as String)
            : const StartPage();
  }
}

// import 'dart:async';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
// // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();
//
// // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;
//   final frontCam = cameras[0];
//
//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: frontCam,
//       ),
//     ),
//   );
// }
//
// // A screen that allows users to take a picture using a given camera.
// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;
//
//   const TakePictureScreen({
//     Key? key,
//     required this.camera,
//   }) : super(key: key);
//
//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }
//
// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );
//
// // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//
//
//     getImage();
//   }
//
//   getImage() async {
//     try {
//       // Ensure that the camera is initialized.
//       await _initializeControllerFuture;
//       // Construct the path where the image should be saved using the
//       // pattern package.
//       final path = join(
//         // Store the picture in the temp directory.
//         // Find the temp directory using the `path_provider` plugin.
//         (await getTemporaryDirectory()).path,
//         '${DateTime.now()}.png',
//       );
//
//       // Attempt to take a picture and log where it's been saved.
//       XFile img = await _controller.takePicture();
//
//       // If the picture was taken, display it on a new screen.
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DisplayPictureScreen(imagePath: img.path),
//         ),
//       );
//     } catch (e) {
//       // If an error occurs, log the error to the console.
//       print(e);
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Take a picture')),
//       // Wait until the controller is initialized before displaying the
//       // camera preview. Use a FutureBuilder to display a loading spinner
//       // until the controller has finished initializing.
//
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, display the preview.
//             return CameraPreview(_controller);
//           } else {
//             // Otherwise, display a loading indicator.
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.camera_alt),
//         // Provide an onPressed callback.
//         onPressed: () async {
//           // Take the Picture in a try / catch block. If anything goes wrong,
//           // catch the error.
//           try {
//             // Ensure that the camera is initialized.
//             await _initializeControllerFuture;
//             // Construct the path where the image should be saved using the
//             // pattern package.
//             final path = join(
//               // Store the picture in the temp directory.
//               // Find the temp directory using the `path_provider` plugin.
//               (await getTemporaryDirectory()).path,
//               '${DateTime.now()}.png',
//             );
//
//             _controller.setFlashMode(FlashMode.off);
//             // Attempt to take a picture and log where it's been saved.
//             XFile img = await _controller.takePicture();
//
//             // If the picture was taken, display it on a new screen.
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(imagePath: img.path),
//               ),
//             );
//           } catch (e) {
//             // If an error occurs, log the error to the console.
//             print(e);
//           }
//         },
//       ),
//     );
//   }
// }
//
// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({Key? key, required this.imagePath})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
