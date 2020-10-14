import 'package:easy_park/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:convert';

import 'package:toast/toast.dart';

class PaymentMethods extends StatefulWidget {
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController controllerNumber =
      MaskedTextController(mask: '0000 0000 0000 0000');
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDate = MaskedTextController(mask: '00/00');
  TextEditingController controllerCvv = MaskedTextController(mask: '000');
  @override
  void initState() {
    super.initState();
    database.reference().child('Users').child(_auth.currentUser.uid).once().then((value){
      if(value.value['credit_card']!=null){
        setState(() {
          controllerName.text = value.value['credit_card']['name'].toString();
          controllerDate.text = value.value['credit_card']['expire_date'].toString();
          controllerNumber.text= value.value['credit_card']['number'].toString();
          controllerCvv.text = utf8.decode(base64Url.decode(value.value['credit_card']['cvv'].toString()));  
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Widgets.caixaDeTextoPagamento(
                          'Number', controllerNumber, TextInputType.number),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Widgets.caixaDeTextoPagamento(
                            'Name', controllerName, TextInputType.text),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Widgets.caixaDeTextoPagamento('Expire Date',
                            controllerDate, TextInputType.number),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Widgets.caixaDeTextoPagamento(
                            'CVV', controllerCvv, TextInputType.number,
                            obs: true),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: save,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.center,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Text(
                  'SAVE',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  save() {
    if (controllerNumber.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid number.', context);
      return;
    }
    if (controllerName.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid name.', context);
      return;
    }
    if (controllerDate.text.isEmpty) {
      Widgets.showDialog(
          'Warning', 'Fill in with a valid expire date.', context);
      return;
    }
    if (controllerCvv.text.isEmpty) {
      Widgets.showDialog('Warning', 'Fill in with a valid cvv.', context);
      return;
    }
    database
        .reference()
        .child('Users')
        .child(_auth.currentUser.uid)
        .child('credit_card')
        .update({
      'name': controllerName.text,
      'expire_date': controllerDate.text,
      'number': controllerNumber.text,
      'cvv': base64Url.encode(utf8.encode(controllerCvv.text))
    }).then((value){
      Toast.show('Saved', context,duration: Toast.LENGTH_LONG);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
