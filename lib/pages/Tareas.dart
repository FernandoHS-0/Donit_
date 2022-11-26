import 'package:donit/models/grupo.dart';
import 'package:donit/objectbox.g.dart';
import 'package:donit/models/tarea.dart';
import 'package:donit/pages/AgregarTarea.dart';
import 'package:flutter/material.dart';

class Tareas extends StatefulWidget {
  const Tareas({required this.grupo, required this.store, Key? key})
      : super(key: key);

  final Grupo grupo;
  final Store store;

  @override
  State<Tareas> createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  late final Store _store;
  late final Box<Tarea> _tareasBox;
  final textController = TextEditingController();

  final _tareas = <Tarea>[];
  Color bgColor = Color(0xFFB6EEFC);

  void _onSave() {
    final descripcion = textController.text.trim();
    if (descripcion.isNotEmpty) {
      textController.clear();
      final tarea = Tarea(descripcion: descripcion);
      tarea.grupo.target = widget.grupo;
      widget.store.box<Tarea>().put(tarea);
      _reloadTsaks();
    }
  }

  void _reloadTsaks() {
    _tareas.clear();
    QueryBuilder<Tarea> builder = widget.store.box<Tarea>().query();
    builder.link(Tarea_.grupo, Grupo_.id.equals(widget.grupo.id));
    Query<Tarea> query = builder.build();
    List<Tarea> resultadosT = query.find();
    setState(() {
      _tareas.addAll(resultadosT);
    });
    query.close();
  }

  void _onUpdate(int index, bool completed) {
    final tarea = _tareas[index];
    tarea.completada = completed;
    widget.store.box<Tarea>().put(tarea);
    _reloadTsaks();
  }

  void _onDelete(Tarea tarea) {
    widget.store.box<Tarea>().remove(tarea.id);
    _reloadTsaks();
  }

  void _loadTareas() {
    _tareas.clear();
    setState(() {
      _tareas.addAll(_tareasBox.getAll());
    });
  }

  Future<void> _agregarTarea() async {
    final resultado = await showDialog(
      context: context,
      builder: (_) => const AgregarTarea(),
    );

    if (resultado != null && resultado is Tarea) {
      _tareasBox.put(resultado);
      _loadTareas();
    }
  }

  @override
  void initState() {
    _tareas.addAll(List.from(widget.grupo.tareas));
    bgColor = Color(widget.grupo.color);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.grupo.nombre,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 30),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tareas.length,
                itemBuilder: (context, index) {
                  final tarea = _tareas[index];
                  return Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Material(
                      elevation: 20,
                      shadowColor: Colors.black.withAlpha(90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(0),
                          right: Radius.circular(50),
                        ),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity(vertical: 4),
                        tileColor: tarea.completada
                            ? Color(0xFFA0D892)
                            : Color(0xFFB6EEFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(0),
                            right: Radius.circular(50),
                          ),
                        ),
                        title: Text(
                          tarea.descripcion,
                          style: TextStyle(
                            decoration: tarea.completada
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        leading: Checkbox(
                          checkColor: Colors.white,
                          value: tarea.completada,
                          onChanged: ((value) => _onUpdate(index, value!)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () => _onDelete(tarea),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("+"),
        onPressed: () {
          _agregarTarea();
        },
      ),
    );
  }
}
