/*
* Chatting Page
* Front_Owner: KimYounghun
*/
import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:handong_manna/constants/color_constants.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.mainBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: ColorPalette.mainBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorPalette.mainWhite,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/chat_profile');
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width*0.06,
                          //TODOLIST: load image from Database
                          backgroundImage: null,
                          child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                        radius: MediaQuery.of(context).size.width*0.025,
                                        backgroundColor: Colors.white,
                                        //TODOLIST: online -> green offline -> green
                                        child: CircleAvatar(
                                            radius: MediaQuery.of(context).size.width*0.020,
                                            backgroundColor: Colors.green
                                        )
                                    )
                                )
                              ]
                          )
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02),
                    Text("떠나간오리\nOnline")
                  ],
                ),
              ],
            ),
            // Expanded(
            //   child: Center(child: Text('Test')),
            // ),
          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsets.fromLTRB(0,0,MediaQuery.of(context).size.width*0.08,0),
              child: Row(
                children: [
                  Text("7"),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Icon(
                    Icons.chat,
                    color: ColorPalette.mainWhite,
                  ),
                ],
              )
          ),
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        child: Chat(
          bubbleBuilder: _bubbleBuilder,
          theme: const DefaultChatTheme(
              inputBackgroundColor: ColorPalette.weakWhite,
              inputTextColor: ColorPalette.strongGray,
              sendButtonIcon: Icon(
                Icons.send,
                color: ColorPalette.mainBlue,
              ),
              backgroundColor: ColorPalette.mainWhite,
              primaryColor: ColorPalette.mainBlue),
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      ),
    );
  }

  Widget _bubbleBuilder(
      Widget child, {
        required message,
        required nextMessageInGroup,
      }) =>
      Bubble(
        child: child,
        padding: const BubbleEdges.fromLTRB(2, 0, 2, 0),
        color: _user.id != message.author.id ||
            message.type == types.MessageType.image
            ? ColorPalette.weakWhite
            : ColorPalette.mainBlue,
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nipWidth: 2,
        nipHeight: 15,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : _user.id != message.author.id
            ? BubbleNip.leftBottom
            : BubbleNip.rightBottom,
        borderWidth: MediaQuery.of(context).size.width*0.02,
        radius: const Radius.circular(20.0),
      );

  void _addMessage(types.Message message) {
    setState(() {
      // 여기에 StreamBuilder 사용해서 들어오는 메세지들 .insert시켜주면 됨.
      // 추가 시키면서 서버에도 푸시를 진행해줘야함.
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }
}
