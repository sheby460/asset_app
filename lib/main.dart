import 'package:asset_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/login_screen.dart';
import 'nav/bottom_nav.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App Demo',
      theme: ThemeData(
         textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
         ),
        primarySwatch: Colors.blue,
      ),
       home: FirebaseAuth.instance.currentUser == null? const LoginScreen() :const BottomBarView(),
    );
  }
}

