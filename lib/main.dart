import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handong_manna/pages/chat_page.dart';
import 'package:handong_manna/pages/chat_profile_page.dart';
import 'package:handong_manna/pages/edit_profile_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the binding is initialized
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
    return MaterialApp(
      title: 'Handong Manna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/chat',
      onGenerateRoute: (settings){
        switch (settings.name){
          case '/chat':
            return MaterialPageRoute(builder: (context)=>ChatPage());

          case '/chat_profile':
            return MaterialPageRoute(builder: (context)=>ChatProfilePage());

          case '/edit_profile':
            return MaterialPageRoute(builder: (context)=>EditProfilePage());
        }
      },
    );
  }
}