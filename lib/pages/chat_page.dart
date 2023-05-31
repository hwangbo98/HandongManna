
/*
* Chatting Page
* Front_Owner: KimYounghun
*/
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:handong_manna/constants/constants.dart';
import 'package:handong_manna/models/models.dart';
import 'package:handong_manna/pages/chat_profile_page.dart';
import 'package:handong_manna/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';


String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

String randomName() {
  final id1 = Random().nextInt(listDongsa.length);
  final id2 = Random().nextInt(listMyeongsa.length);
  return listDongsa[id1] + listMyeongsa[id2];
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  QueryDocumentSnapshot? _lastDocument;
  final List<types.Message> _messages = [];
  types.User _user = const types.User(id: "");
  int _messageCount = 0;

  String groupChatId = "";
  final int _limit = 30;

  String username = randomName();
  ChatProvider? chatProvider;

  final AutoScrollController _scrollController = AutoScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) async { 
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      var userId = authProvider.getUserFirebaseId();
      if (userId != null) {
        _user = types.User(id: userId);
        await setGroupChatId(userId);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0 && !_isLoading) {
          print('Chat list scolled to top');
          _loadMoreMessages();
        }
      }
    });
  }

  void _loadMoreMessages() async {
    if (_lastDocument != null && !_isLoading) {
      _isLoading = true;
      var newMessageDocs = await chatProvider!.getChatStream(groupChatId, _limit, _lastDocument).first;

      setState(() {
        _messages.addAll(newMessageDocs.docs.map((doc) {
          final message = MessageChat.fromDocument(doc);
          return message.toChatTypeMessage(_user);
        }).toList());

        _lastDocument = newMessageDocs.docs.last;
        _isLoading = false;
      });
    }
  }

  Future<void> setGroupChatId(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    String opponentId = userDoc.get('chattingWith');
    setState(() {
      groupChatId = "";
      groupChatId += userId.compareTo(opponentId) < 0
          ? "$userId-$opponentId"
          : "$opponentId-$userId";
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (groupChatId != "") {
      chatProvider!.getMessageCount(groupChatId).then((count) {
        setState(() {
          _messageCount = count;
        });
      });
    }
  }

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
                      onTap: () {
                        if(_messageCount > 200){
                          Navigator.pushNamed(context, '/chat_profile',
                              arguments: ChatProfilePageArguments(
                                  isNameOpen: true,
                                  isIntroduceOpen: true,
                                  isProfileOpen: true,
                                  isOccupationOpen: true));
                        }else if(_messageCount > 150){
                          Navigator.pushNamed(context, '/chat_profile',
                              arguments: ChatProfilePageArguments(
                                  isNameOpen: true,
                                  isIntroduceOpen: true,
                                  isProfileOpen: false,
                                  isOccupationOpen: true));
                        }else if(_messageCount > 100){
                          Navigator.pushNamed(context, '/chat_profile',
                              arguments: ChatProfilePageArguments(
                                  isNameOpen: false,
                                  isIntroduceOpen: true,
                                  isProfileOpen: false,
                                  isOccupationOpen: true));
                        }else if(_messageCount > 50){
                          Navigator.pushNamed(context, '/chat_profile',
                              arguments: ChatProfilePageArguments(
                                  isNameOpen: false,
                                  isIntroduceOpen: true,
                                  isProfileOpen: false,
                                  isOccupationOpen: false));
                        }else{
                          Navigator.pushNamed(context, '/chat_profile',
                              arguments: ChatProfilePageArguments(
                                  isNameOpen: false,
                                  isIntroduceOpen: false,
                                  isProfileOpen: false,
                                  isOccupationOpen: false));
                        }
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.06,
                          //TODOLIST: load image from Database
                          backgroundImage: null,
                          child: Stack(children: [
                            Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.width *
                                        0.025,
                                    backgroundColor: Colors.white,
                                    //TODOLIST: online -> green offline -> green
                                    child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.020,
                                        backgroundColor: Colors.green)))
                          ])),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("$username\nOnline")
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
              padding: EdgeInsets.fromLTRB(
                  0, 0, MediaQuery.of(context).size.width * 0.08, 0),
              child: Row(
                children: [
                  Text("$_messageCount"),
                  // TODO: Change to the number of existing messages
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  const Icon(
                    Icons.chat,
                    color: ColorPalette.mainWhite,
                  ),
                ],
              )),
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        // Replace 'groupChatId' with the appropriate variable
        child: StreamBuilder<QuerySnapshot>(
          // stream: _messagesRef.orderBy(FirestoreConstants.timestamp, descending: true).snapshots(),
          stream: getChatStream(context, groupChatId, _limit),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (groupChatId != "") {
              chatProvider!.getMessageCount(groupChatId).then((count) {
                setState(() {
                  _messageCount = count;
                });
              });
            }

            // Todo: fill _messages
            _messages.clear();
            _messages.addAll(
              snapshot.data!.docs.map((doc) {
                final message = MessageChat.fromDocument(doc);
                return message.toChatTypeMessage(_user);
              }).toList(),
            );

            if (_user.id != "") {
              return Chat(
                key: ValueKey(_messages.length),
                scrollController: _scrollController,
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
                user: _user!,
              );
            } else {
              // return some kind of error widget
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorPalette.mainWhite,
                )
              );
            }
          },
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
        borderWidth: MediaQuery.of(context).size.width * 0.02,
        radius: const Radius.circular(20.0),
        child: child,
      );

  Stream<QuerySnapshot> getChatStream(
      BuildContext context, String groupChatId, int limit) {
    if (groupChatId.isEmpty) {
      return Stream<QuerySnapshot>.empty();
    }

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return chatProvider.getChatStream(groupChatId, limit, _lastDocument);
  }

  void _handleSendPressed(types.PartialText message) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(
      message.text,
      1,
      groupChatId, 
      _user.id,
      groupChatId.replaceAll(_user.id, "").replaceAll("-", ""),
    );
    if (groupChatId != "") {
      chatProvider.getMessageCount(groupChatId).then((count) {
        chatProvider.setMessageCount(groupChatId, count + 1);
      });
    }
  }
}
