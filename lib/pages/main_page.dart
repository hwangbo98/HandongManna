import 'package:flutter/material.dart';
import 'package:handong_manna/providers/auth_providers.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Handong Manna"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authProvider.handleSignOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/plane.png'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
              'Corinthians 13:13',
              style: const TextStyle(
                fontSize: 20,
              ),
              )),
            Text(
              'And now these three remain: faith, hope and love. But the greatest of these is love.',
              style: const TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            StreamBuilder(
              stream: authProvider.matchingState(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else{
                  if (snapshot.data == 1) {
                    return CircularProgressIndicator();
                  }
                  else if(snapshot.data == 0){
                    return ElevatedButton(
                      onPressed: () {
                        authProvider.performMatching();
                      },
                      child: Text('Chatting Start !'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.all(10.0),
                        ),
                        overlayColor: MaterialStateProperty.all(Colors.black),
                      ),
                    );
                  }
                  else{
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushNamed(context, '/chat');});
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0), // Add vertical padding
                      child: ElevatedButton(
                        child: Text('Go to Chat Room!'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(10.0),
                          ),
                          overlayColor: MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),
                    );
                  }
                }
              }) 
          ],
        ),
      ),
    );// This trailing comma makes auto-formatting nicer for build methods.
  }
}