import 'package:easy_park/home.dart';
import 'package:easy_park/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cadastro.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 5.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?',
                        style:
                            TextStyle(color: Color.fromRGBO(70, 151, 156, 1)),
                      )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: () {
                    loginUser(context);
                  },
                  child: Image.asset(
                    'assets/login.png',
                    fit: BoxFit.contain,
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?  ',
                  ),
                  GestureDetector(
                    onTap: () {
                      //Colocar aqui pra rederecionar para tela de cadasro
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Cadastro()));
                    },
                    child: Text(
                      'Sign up here',
                      style: TextStyle(color: Color.fromRGBO(70, 151, 156, 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginUser(BuildContext context) async {
    if (controllerEmail.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid email.', context);
      return;
    }
    if (controllerPassword.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid password.', context);
      return;
    }
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      ))
          .user;

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("${user.email} signed in"),
      ));
      await Future.delayed(Duration(milliseconds: 1300));
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => MyHomePage()), (route) => false);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Email & Password"),
      ));
    }
  }
}
