import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handong_manna/pages/chat_page.dart';
import 'package:handong_manna/pages/chat_profile_page.dart';
import 'package:handong_manna/pages/edit_profile_page.dart';
import 'package:handong_manna/pages/login_page.dart';
import 'package:handong_manna/pages/main_page.dart';
import 'package:handong_manna/pages/register_page.dart';
import 'package:handong_manna/pages/splash_page.dart';

import 'package:handong_manna/providers/chat_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // TODO: Add the other providers
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Handong Manna',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splash',
        onGenerateRoute: (settings){
          switch (settings.name){
            case '/splash':
              return MaterialPageRoute(builder: (context)=>SplashPage());

            case '/edit_profile':
              return MaterialPageRoute(builder: (context)=>EditProfilePage());

            case '/main':
              return MaterialPageRoute(builder: (context)=>MainPage());

            case '/register':
              return MaterialPageRoute(builder: (context)=>RegisterPage());

            case '/login':
              return MaterialPageRoute(builder: (context)=>LoginPage());

            case '/chat':
              return MaterialPageRoute(builder: (context)=>ChatPage());

            case '/chat_profile':
              return MaterialPageRoute(builder: (context)=>ChatProfilePage());
          }
        },
      ),
    );
  }
}