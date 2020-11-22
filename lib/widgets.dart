import 'package:easy_park/pagamento.dart';
import 'package:easy_park/payment_methods.dart';
import 'package:easy_park/vaga_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/vaga.dart';

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
                    : labelText == 'Nome'
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

  static Widget itemVaga(
      {@required Vaga vaga, @required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: ListTile(
          onTap: () {
            if (vaga.Status == 'ocupado') {
              showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                          title: Text('Aviso'),
                          content: Text('Você está estacionado nesta vaga?'),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Pagamento(vaga)));
                                },
                                child: Text(
                                  'SIM',
                                  style: TextStyle(color: Colors.blue),
                                )),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'NÃO',
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ]));
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => VagaInfo(vaga)));
            }
          },
          leading: Icon(
            Icons.circle,
            color: vaga.Status == 'ocupado' ? Colors.red : Colors.green,
          ),
          title: Text(
              'Vaga #${vaga.Numero}, ${vaga.Info.contains('Azul') ? 'Bloco Azul' : 'Bloco Vermelho'}'),
          trailing: Text(vaga.Status == 'ocupado' ? 'OCUPADO' : 'LIVRE'),
        ),
      ),
    );
  }

  static showDialogToChangeCreditCard(
      String title, String content, BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: Text('$title'),
                content: Text('$content'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PaymentMethods(
                                      isPayment: true,
                                    )));
                      },
                      child: Text(
                        'SIM',
                        style: TextStyle(color: Colors.blue),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'NÃO',
                        style: TextStyle(color: Colors.blue),
                      ))
                ]));
  }
}
