import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/HandongMannaLogo.png'),
              SizedBox(
                height: 30,
              ),
              Text(
                'Chat and connect with verified Handong singles seeking serious relationships',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 30,
              ),
              SignInButton(
                  buttonType: ButtonType.google,
                  buttonSize: ButtonSize.large,
                  // small(default), medium, large
                  onPressed: () {
                    //여깅에서 로그인 버튼 눌렀을 때 알고리즘 진행하면 됨
                    // 1. 파이어베이스에 올리기
                    // 2. SharedPreference로 로그인 token 저장하기(나중에 자동로그인)
                    Navigator.pushNamed(context, '/main');
                  }),
              SizedBox(
                height: 50,
              ),
              Text(
                'By Signing in, you agree to our Terms and Conditions, Learn how we use your data in our Privacy Policy.',
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }
}
