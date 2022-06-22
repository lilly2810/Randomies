import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: WelcomeScreen(),

      ),
    );
  }
}
