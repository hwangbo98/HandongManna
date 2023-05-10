import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handong_manna/pages/register_page.dart';

import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../providers/auth_providers.dart';
// import '../widgets/loading_view.dart';
// import '../widgets/widgets.dart';
import 'main_page.dart';
// import 'pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
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
                  onPressed: () async {
                    authProvider.handleSignIn().then((isSuccess) {
                      if (isSuccess) {
                        if(authProvider.first()){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistersPage(),
                            ),
                          );
                        }
                        else{
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(),
                            ),
                          );
                        }
                      }
                    }).catchError((error, stackTrace) {
                      Fluttertoast.showToast(msg: error.toString());
                      authProvider.handleException();
                    });
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
