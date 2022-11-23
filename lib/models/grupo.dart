import 'package:donit/models/tarea.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

@Entity()
class Grupo {
  int id = 0;
  String nombre;
  int color;

  @Backlink()
  final tareas = ToMany<Tarea>();

  Grupo({
    required this.nombre,
    required this.color,
  });

  String descripcionDeTarea() {
    final tareasCompletadas = tareas.where((tarea) => tarea.completada).length;
    if (tareas.isEmpty) {
      return '';
    } else {
      return '$tareasCompletadas de ${tareas.length}';
    }
  }
}
