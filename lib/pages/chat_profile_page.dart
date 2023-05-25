/*
* Profile Page
* Front_Owner: KimYounghun
*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:handong_manna/constants/app_constants.dart';
import 'package:handong_manna/constants/color_constants.dart';
import 'package:handong_manna/models/models.dart';
import 'package:handong_manna/providers/chat_providers.dart';
import 'package:provider/provider.dart';

class ChatProfilePageArguments{
  ChatProfilePageArguments({required this.isNameOpen, required this.isOccupationOpen, required this.isIntroduceOpen, required this.isProfileOpen});
  final bool isNameOpen;
  final bool isOccupationOpen;
  final bool isIntroduceOpen;
  final bool isProfileOpen;
}

class ChatProfilePage extends StatefulWidget {

  const ChatProfilePage({Key? key}) : super(key: key);

  @override
  _ChatProfilePageState createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends State<ChatProfilePage> {

  bool isNameOpen = false;
  bool isOccupationOpen = false;
  bool isIntroduceOpen = false;
  bool isProfileOpen = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as ChatProfilePageArguments?
        ?? ChatProfilePageArguments(isNameOpen: false, isOccupationOpen: false, isIntroduceOpen: false, isProfileOpen: false);
    print(args.isIntroduceOpen);
    print(args.isProfileOpen);
    print(args.isOccupationOpen);
    print(args.isNameOpen);
    return Scaffold(
      backgroundColor: ColorPalette.mainBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: ColorPalette.mainBlue,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.04, 0, 0, 0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.mainWhite,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text('Profile'),
      ),
      body: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          child: Container(
            color: ColorPalette.mainWhite,
            child: ListView(
              children: [
                Padding(
                  padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(48), // Image radius
                      child: BlurImage(
                          imageUrl: 'https://picsum.photos/250?image=9',
                          blurIntensity: args.isProfileOpen ? 0.0 : 10.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.03,
                      MediaQuery.of(context).size.width * 0.03,
                      0,
                      MediaQuery.of(context).size.width * 0.01),
                  child: Text(
                    "한아람",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.03, 0, 0, 0),
                      child: const FaIcon(FontAwesomeIcons.instagram),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: BlurText(
                        content: " haram_1004",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.03),
                        blurIntensity: args.isNameOpen ? 0 : 10,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  child: Text(
                    "Occupation",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: BlurText(
                    content: " Student",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                    blurIntensity: args.isOccupationOpen ? 0 : 10,
                  ),
                ),
                Divider(),
                Padding(
                  padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  child: Text(
                    "About Me",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: BlurText(
                    content: " I Love apple",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                    blurIntensity: args.isIntroduceOpen ? 0 : 10,
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button press logic here
                      Navigator.pushNamed(context, '/main');
                    },
                    child: Text('채팅방 나가기'),
                    style: ElevatedButton.styleFrom(
                      primary: ColorPalette.mainWhite,
                      onPrimary: ColorPalette.profileRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: ColorPalette
                                .profileRed), // Set edge side color and width
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
