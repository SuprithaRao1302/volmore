import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volmore/firebase_options.dart';
import 'package:volmore/routes/routes.dart';
import 'package:volmore/screens/home.dart';
import 'package:volmore/screens/login.dart';

var uid;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  uid = sharedPreferences.getString('uid');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VolMore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: getRoutes(),
      home: uid != ""
          ? HomeScreen()
          : LoginScreen(), // Replace MyHomePage with LoginPage
    );
  }
}
