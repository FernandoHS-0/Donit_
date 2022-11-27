import 'package:donit/models/grupo.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Tarea {
  int id = 0;
  String titulo;
  String descripcion;
  bool completada = false;
  DateTime fecha;

  final grupo = ToOne<Grupo>();

  Tarea({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
  });
}
