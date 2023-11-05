import 'package:admin_web_portal/authentication/login_screen.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: FirebaseOptions(
      apiKey: "AIzaSyDfJEru2tE08G295xGgnEKjzbeKcbhqXAw",
      authDomain: "valley-craft.firebaseapp.com",
      projectId: "valley-craft",
      storageBucket: "valley-craft.appspot.com",
      messagingSenderId: "20903340495",
      appId: "1:20903340495:web:29a110110049001f944aba",
      measurementId: "G-M3XPQYCSGG"
  ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Portal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null ? HomeScreen() : LoginScreen(),
    );
  }
}

