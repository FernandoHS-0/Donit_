import 'package:donit/models/grupo.dart';
import 'package:donit/objectbox.g.dart';
import 'package:donit/models/tarea.dart';
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
  final textController = TextEditingController();

  final _tareas = <Tarea>[];
  Color bgColor = Colors.primaries.first;

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
        title: Text(widget.grupo.nombre),
        backgroundColor: bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Tarea',
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              color: Colors.blue,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Crear tarea',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: _onSave,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tareas.length,
                itemBuilder: (context, index) {
                  final tarea = _tareas[index];
                  return ListTile(
                    title: Text(
                      tarea.descripcion,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: ((value) => _onUpdate(index, value!)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _onDelete(tarea),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
