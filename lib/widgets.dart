import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widgets {
  static Widget caixaDeTexto(
      String labelText, TextEditingController controller, ImageIcon imageIcon,
      {bool obs = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        obscureText: obs,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: imageIcon != null
                    ? imageIcon
                    : labelText == 'Name'
                        ? Icon(
                            Icons.person,
                            size: 35,
                          )
                        : null),
            labelText: '$labelText'),
      ),
    );
  }

  static Widget caixaDeTextoPagamento(String labelText,
      TextEditingController controller, TextInputType textInputType,
      {bool obs = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        obscureText: obs,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
        
            prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.credit_card)),
            labelText: '$labelText'),
      ),
    );
  }

  static showDialog(String title, String content, BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: Text('$title'),
                content: Text('$content'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.blue),
                      ))
                ]));
  }
}
