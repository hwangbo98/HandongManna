import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // wrap with MaterialApp
      title: 'Edit Profile',
      home: Scaffold(
        appBar: AppBar(
          title: Text('내 프로필'),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [TextButton(
            style: TextButton.styleFrom( primary: Colors.white ),
            onPressed: () {
            },
            child: Text("저장"),
          ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Container(
              padding: EdgeInsets.all(20.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '프로필 수정\n',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    TextSpan(
                      text: 'PUBLIC PROFILE\n',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('이름'),
              trailing: const Text('박주영'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.flag_rounded),
              title: const Text('학번'),
              trailing: const Text('21800314'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.house_rounded),
              title: const Text('RC'),
              trailing: const Text('장기려RC'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.local_florist_rounded),
              title: const Text('나이'),
              trailing: const Text('25'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.school_rounded),
              title: const Text('직업/전공'),
              trailing: const Text('CEO'),
              onTap: () {},
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'PRIVATE DETAIL\n',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email_rounded),
              title: const Text('Email'),
              trailing: const Text('21800314@handong.ac.kr'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone_iphone_rounded),
              title: const Text('Phone'),
              trailing: const Text('010-1234-5678'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.pop(context);
    }
  }
}