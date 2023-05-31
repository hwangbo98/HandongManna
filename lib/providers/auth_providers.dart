import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handong_manna/constants/constants.dart';
import 'package:handong_manna/models/user_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;
  bool firstUser = false;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });

  Future<void> performMatching() async {
    String? currentUserID = getUserFirebaseId();

    DocumentSnapshot userSnapshot = await firebaseFirestore
      .collection(FirestoreConstants.pathUserCollection)
      .doc(currentUserID)
      .get();


    firebaseFirestore.collection("waiting_list").doc(currentUserID).set({
          "id" : currentUserID,
          "sex": 1,
    });
    firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(currentUserID).update({
          FirestoreConstants.ismatching: 1,
    });

    final sfDocRef = FirebaseFirestore.instance.collection('waiting_list').where("id", isNotEqualTo: currentUserID);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      // String matchedWith = userSnapshot.get('chattingWith');
      if (!(userSnapshot.get('chattingWith').isEmpty)) {
        return;
      }
      QuerySnapshot querySnapshot = await sfDocRef.get();
      querySnapshot.docs.removeWhere((doc) => doc.id == currentUserID);
      if (querySnapshot.size >= 1) {
        
        List<QueryDocumentSnapshot> queueDocs = querySnapshot.docs;

        List<int> indices = List.generate(queueDocs.length, (index) => index);
        indices.shuffle();
        List<QueryDocumentSnapshot> matchedUsers = queueDocs.sublist(0, 1);
        String id="";
        WriteBatch batch = FirebaseFirestore.instance.batch();
        for (QueryDocumentSnapshot userDoc in matchedUsers) {
          id = userDoc.id;
          batch.update(
            firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(userDoc.id),
            {
              "chattingWith": currentUserID,
              FirestoreConstants.ismatching: 2,
            },
          );
        }
        batch.update(
          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(currentUserID),
          {
            "chattingWith": id,
            FirestoreConstants.ismatching: 2,
          },
        );

        for (QueryDocumentSnapshot userDoc in matchedUsers) {
          batch.delete(userDoc.reference);
        }
        batch.delete(firebaseFirestore.collection("waiting_list").doc(currentUserID));

        await batch.commit();
      }
    });
  }


  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstants.id);
  }

  Stream<int> matchingState() {
    String? userId = getUserFirebaseId();
    StreamController<int> controller = StreamController<int>();

    if (userId != null) {
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(userId)
          .snapshots()
          .listen((DocumentSnapshot userSnapshot) {
        int isMatching = userSnapshot.get(FirestoreConstants.ismatching);
        controller.add(isMatching);
      });
    }
    return controller.stream;
  }

  Future<void> matchStart() async{
      firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(getUserFirebaseId()).update({
            FirestoreConstants.ismatching: 1,
      });
      firebaseFirestore.collection("waiting_list").doc(getUserFirebaseId()).set({
            "sex": 1,
      });
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future handleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) { //success to google login
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential( //bring google login information.
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user; // signwithcredential in firebase.

      if (firebaseUser != null) { 
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Writing data to server because here is a new user
          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstants.nickname: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null,
          });
          firstUser = true;
          // Write data to local storage
          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
          await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
        } else {
          // Already sign up, just get data from firestore
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
          await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        }
        _status = Status.authenticated;
        firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).update({
            FirestoreConstants.isLogin: true,
            FirestoreConstants.ismatching: 0,
            
        });
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else { //fail to google login
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  bool first(){
    return firstUser;
  }

  void handleException() {
    _status = Status.authenticateException;
    notifyListeners();
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    String? userId = getUserFirebaseId();
    if (userId != null) {
      await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(userId)
          .update({FirestoreConstants.isLogin: false});
    }
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
