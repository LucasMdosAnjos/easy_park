import 'dart:async';

import 'package:easy_park/models/vaga.dart';
import 'package:easy_park/repository/i_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeRepository implements IVagasRepository {
  @override
  Stream<List<Vaga>> vagas({int filtro}) {
    if (filtro == null) {
      return FirebaseDatabase.instance
          .reference()
          .child('Vagas')
          .onValue
          .map((event) {
        if (event.snapshot.value is Map) {
          List<Vaga> list =
              List.from(Map.from(event.snapshot.value).values.toList())
                  .where((element) => element != null)
                  .map((element) {
            return Vaga(
                numero: element['numero'],
                status: element['status'],
                info: element['info']);
          }).toList();
          list.sort((a, b) => a.Numero.compareTo(b.Numero));
          return list;
        }
        List<Vaga> list = List.from(event.snapshot.value)
            .where((element) => element != null)
            .map((element) {
          return Vaga(
              numero: element['numero'],
              status: element['status'],
              info: element['info']);
        }).toList();
        list.sort((a, b) => a.Numero.compareTo(b.Numero));
        return list;
      });
    }
    switch (filtro) {
      case 0:
        return FirebaseDatabase.instance
            .reference()
            .child('Vagas')
            .orderByChild('status')
            .equalTo('livre')
            .onValue
            .map((event) {
          if (event.snapshot.value is Map) {
            List<Vaga> list =
                List.from(Map.from(event.snapshot.value).values.toList())
                    .where((element) => element != null)
                    .map((element) {
              return Vaga(
                  numero: element['numero'],
                  status: element['status'],
                  info: element['info']);
            }).toList();
            list.sort((a, b) => a.Numero.compareTo(b.Numero));
            return list;
          }
          List<Vaga> list = List.from(event.snapshot.value)
              .where((element) => element != null)
              .map((element) {
            return Vaga(
                numero: element['numero'],
                status: element['status'],
                info: element['info']);
          }).toList();
          list.sort((a, b) => a.Numero.compareTo(b.Numero));
          return list;
        });
        break;
      case 1:
        return FirebaseDatabase.instance
            .reference()
            .child('Vagas')
            .orderByChild('status')
            .equalTo('ocupado')
            .onValue
            .map((event) {
          if (event.snapshot.value is Map) {
            List<Vaga> list =
                List.from(Map.from(event.snapshot.value).values.toList())
                    .where((element) => element != null)
                    .map((element) {
              return Vaga(
                  numero: element['numero'],
                  status: element['status'],
                  info: element['info']);
            }).toList();
            list.sort((a, b) => a.Numero.compareTo(b.Numero));
            return list;
          }
          List<Vaga> list = List.from(event.snapshot.value)
              .where((element) => element != null)
              .map((element) {
            return Vaga(
                numero: element['numero'],
                status: element['status'],
                info: element['info']);
          }).toList();
          list.sort((a, b) => a.Numero.compareTo(b.Numero));
          return list;
        });
        break;
    }
    return null;
  }
}
