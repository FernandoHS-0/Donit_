import 'package:donit/models/grupo.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Tarea {
  int id = 0;
  String descripcion;
  bool completada = false;

  final grupo = ToOne<Grupo>();

  Tarea({
    required this.descripcion,
  });
}
