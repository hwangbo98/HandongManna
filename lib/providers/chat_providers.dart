import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:handong_manna/constants/constants.dart';
import 'package:handong_manna/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider({required this.firebaseFirestore, required this.prefs, required this.firebaseStorage});

  String? getPref(String key) {
    return prefs.getString(key);
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type, String groupChatId, String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  Future<int> getMessageCount(String groupChatId) async {

    if (groupChatId.isEmpty) {
      throw ArgumentError('groupChatId cannot be empty');
    }
    DocumentReference docRef = firebaseFirestore.collection(FirestoreConstants.pathMessageCollection).doc(groupChatId);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({'count': 0});
      return 0;
    }

    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return data['count'];
    }

  Future<void> setMessageCount(String groupChatId, int count) async {
    await updateDataFirestore(FirestoreConstants.pathMessageCollection, groupChatId, {'count': count});
  }


} 

class TypeMessage {
  static const text = 1;
  static const image = 2;
  static const sticker = 3;
}
