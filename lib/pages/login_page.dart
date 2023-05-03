import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign In Demo',
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Google Sign In Demo'),
        // ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    '/Users/kite/StudioProjects/hm_login/assets/KakaoTalk_Photo_2023-04-26-10-44-16-removebg-preview.png'),
                SizedBox(height: 30,),
                Text(
                  'Chat and connect with verified Handong singles seeking serious relationships',
                  style: TextStyle(fontSize: 15),),
                SizedBox(height: 30,),
                GoogleSignInButton(),
                SizedBox(height: 50,),
                Text(
                    'By Signing in, you agree to our Terms and Conditions, Learn how we use your data in our Privacy Policy.'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        try {
          await _googleSignIn.signIn();
        } catch (error) {
          print(error);
        }
      },

      icon: ImageIcon(
        AssetImage('/Users/kite/StudioProjects/hm_login/assets/google.png'),
        size: 24,
        color: Colors.yellow,
      ),
      style: OutlinedButton.styleFrom(backgroundColor: Colors.blueAccent),
      label: Text('Sign in with Google',
        style: TextStyle(
          // fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white,
        ),),
      // color:
    );
  }
}
