import 'package:easy_park/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'models/vaga.dart';

class Pagamento extends StatefulWidget {
  Vaga vaga;
  Pagamento(this.vaga);
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(9, 174, 181, 1),
        title: Text('Vaga #${widget.vaga.numero}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(widget.vaga.info.contains('Azul')
                        ? 'http://lh3.ggpht.com/pvI-Ub39vJub6-r8jkB8zFR8nuiDuMy1KDQwfitaKLnwnlku8Fde_8DtTTj2LAHqMwigBF7w3SFkzc1GKMtv'
                        : 'https://fastly.4sqi.net/img/general/600x600/13896762_Ow3gGCay-oIOBFZMBh13gKojbv8SRBC7fGHtlhbTEtk.jpg'))),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.vaga.Info,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                          title: Text('Aviso'),
                          content: Text(
                              'Deseja pagar o estacionamento da vaga #${widget.vaga.Numero}?'),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'CANCELAR',
                                  style: TextStyle(color: Colors.red),
                                )),
                            FlatButton(
                                onPressed: () {
                                  FirebaseDatabase.instance
                                      .reference()
                                      .child('Users')
                                      .child(_auth.currentUser.uid)
                                      .once()
                                      .then((value) {
                                    if (value.value['credit_card'] == null) {
                                      Navigator.pop(context);
                                      Widgets.showDialogToChangeCreditCard(
                                          'Aviso',
                                          'Gostaria de inserir um cartão de crédito para finalizar o pagamento?',
                                          context);
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Toast.show(
                                          'Pagamento realizado com sucesso!',
                                          context,
                                          duration: Toast.LENGTH_LONG);
                                    }
                                  });
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.blue),
                                )),
                          ]));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/pay_now.png'))),
            ),
          ),
        ],
      ),
    );
  }
}
