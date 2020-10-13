import 'package:easy_park/payment_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_auth.currentUser == null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Login()), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), centerTitle: true),
      drawer: _auth.currentUser!=null ? StreamBuilder<Event>(
          stream: FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(_auth.currentUser.uid)
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
                break;
              default:
                if (snapshot.hasData) {
                  return Drawer(
                    child: Column(
                      children: [
                        UserAccountsDrawerHeader(
                            currentAccountPicture: Image.asset(
                                'assets/icone.png',
                                fit: BoxFit.contain),
                            accountName: Text(
                              snapshot.data.snapshot.value['name'],
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            accountEmail: _auth.currentUser != null
                                ? Text(
                                    _auth.currentUser.email,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container()),
                        Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentMethods()));
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.credit_card,
                                color: Colors.blue,
                              ),
                              title: Text(
                                'Payment Methods',
                                style: TextStyle(fontSize: 17.5),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: InkWell(
                            onTap: () {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                          title: Text('Warning'),
                                          content:
                                              Text('Do you want to log out?'),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                            FlatButton(
                                                onPressed: () {
                                                  _auth.signOut().then((value) {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    Login()),
                                                            (route) => false);
                                                  });
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )),
                                          ]));
                              _auth.signOut().then((value) => null);
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.settings_power_outlined,
                                color: Colors.blue,
                              ),
                              title: Text(
                                'Log out',
                                style: TextStyle(fontSize: 17.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
            }
          }) : Container(),
      body: Container(),
    );
  }
}
