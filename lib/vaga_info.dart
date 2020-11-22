import 'package:flutter/material.dart';

import 'models/vaga.dart';

class VagaInfo extends StatefulWidget {
  Vaga vaga;
  VagaInfo(this.vaga);
  @override
  _VagaInfoState createState() => _VagaInfoState();
}

class _VagaInfoState extends State<VagaInfo> {
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
        ],
      ),
    );
  }
}
