import 'dart:async';

import 'package:easy_park/models/vaga.dart';
import 'package:easy_park/payment_methods.dart';
import 'package:easy_park/repository/i_repository.dart';
import 'package:easy_park/repository/repository_realtime.dart';
import 'package:easy_park/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  IVagasRepository repository = RealtimeRepository();
  int filtro;
  int selected = 0;
  List<Vaga> vagas = List();
  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    getVagas();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_auth.currentUser == null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Login()), (route) => false);
      }
    });
  }

  getVagas() async {
    if (subscription != null) {
      await subscription.cancel();
    }
    subscription = repository.vagas(filtro: filtro).listen((list) {
      setState(() {
        vagas.clear();
        vagas = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vagas'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(9, 174, 181, 1),
        ),
        drawer: _auth.currentUser != null
            ? StreamBuilder<Event>(
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
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(9, 174, 181, 1)),
                                  currentAccountPicture: Image.asset(
                                      'assets/icone.png',
                                      fit: BoxFit.contain),
                                  accountName: Text(
                                    snapshot.data.snapshot.value['name'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PaymentMethods()));
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.credit_card,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      'Dados Bancários',
                                      style: TextStyle(fontSize: 17.5),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () async {
                                    const url = 'https://wa.me/554197358857';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                      Navigator.pop(context);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.support_agent,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      'Suporte',
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
                                                title: Text('Aviso'),
                                                content: Text('Deseja sair?'),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'CANCELAR',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                  FlatButton(
                                                      onPressed: () {
                                                        _auth
                                                            .signOut()
                                                            .then((value) {
                                                          Navigator.pushAndRemoveUntil(
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
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.settings_power_outlined,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      'Encerrar Sessão',
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
                })
            : Container(),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSegmentedControl(
                    groupValue: selected,
                    selectedColor: Color.fromRGBO(9, 174, 181, 1),
                    borderColor: Colors.grey.withOpacity(0.15),
                    unselectedColor: Colors.grey.withOpacity(0.15),
                    pressedColor: Color.fromRGBO(9, 174, 181, 1),
                    children: {
                      0: Text(
                        'Número',
                        style: TextStyle(color: Colors.black),
                      ),
                      1: Text(
                        'Livre',
                        style: TextStyle(color: Colors.black),
                      ),
                      2: Text(
                        'Ocupado',
                        style: TextStyle(color: Colors.black),
                      )
                    },
                    onValueChanged: (value) {
                      switch (value) {
                        case 2:
                          if (filtro != 1) {
                            filtro = 1;
                            selected = 2;
                            getVagas();
                          }
                          break;
                        case 1:
                          if (filtro != 0) {
                            filtro = 0;
                            selected = 1;
                            getVagas();
                          }
                          break;
                        case 0:
                          if (filtro != null) {
                            filtro = null;
                            selected = 0;
                            getVagas();
                          }
                          break;
                      }
                    }),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vagas.length,
                itemBuilder: (BuildContext context, int index) {
                  var vaga = vagas[index];
                  return Widgets.itemVaga(vaga: vaga, context: context);
                },
              ),
            ),
          ],
        ));
  }
}
