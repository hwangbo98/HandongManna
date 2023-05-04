import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handong_manna/constants/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageChat {
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final int type;

  const MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: this.idFrom,
      FirestoreConstants.idTo: this.idTo,
      FirestoreConstants.timestamp: this.timestamp,
      FirestoreConstants.content: this.content,
      FirestoreConstants.type: this.type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String idTo = doc.get(FirestoreConstants.idTo);
    String timestamp = doc.get(FirestoreConstants.timestamp);
    String content = doc.get(FirestoreConstants.content);
    int type = doc.get(FirestoreConstants.type);
    return MessageChat(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content, type: type);
  }

  // Added  method to your MessageChat class
  types.Message toChatTypeMessage(types.User currentUser) {
    return types.TextMessage(
      id: timestamp, // Use the timestamp as the message ID
      author: idFrom == currentUser.id ? currentUser : types.User(id: idTo),
      text: content,
      createdAt: int.parse(timestamp),
      updatedAt: int.parse(timestamp),
    );
  }
}
