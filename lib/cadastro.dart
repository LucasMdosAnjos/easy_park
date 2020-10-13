import 'package:easy_park/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Builder(
        builder: (BuildContext context) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/icone.png',
                          ),
                          fit: BoxFit.contain)),
                ),
              ),
              Widgets.caixaDeTexto('Name', controllerName, null),
              SizedBox(
                height: 10,
              ),
              Widgets.caixaDeTexto(
                'E-mail',
                controllerEmail,
                ImageIcon(
                  AssetImage('assets/email.png'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Widgets.caixaDeTexto(
                  'Password',
                  controllerPassword,
                  ImageIcon(
                    AssetImage('assets/password.png'),
                  ),
                  obs: true),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: () {
                    createUser(context);
                  },
                  child: Image.asset(
                    'assets/SignUp.png',
                    fit: BoxFit.contain,
                  )),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  createUser(BuildContext context) async {
    if (controllerName.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid name.', context);
      return;
    }
    if (controllerEmail.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid email.', context);
      return;
    }
    if (controllerPassword.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid password.', context);
      return;
    }

    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      ))
          .user;
      database
          .reference()
          .child('Users')
          .child(user.uid)
          .set({'name': controllerName.text, 'email': controllerEmail.text});

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("${user.email} created"),
      ));
      await Future.delayed(Duration(milliseconds: 1300));
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => MyHomePage()), (route) => false);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create user."),
      ));
    }
  }
}
