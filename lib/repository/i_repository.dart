import 'package:easy_park/models/vaga.dart';

abstract class IVagasRepository {
  Stream<List<Vaga>> vagas({int filtro});
}