import 'package:donit/services/notifications_services.dart';
import 'package:flutter/material.dart';
import 'package:donit/models/grupo.dart';
import 'package:donit/objectbox.g.dart';
import 'package:donit/models/tarea.dart';

class AgregarTarea extends StatefulWidget {
  const AgregarTarea({required this.grupo, required this.store, Key? key})
      : super(key: key);

  final Grupo grupo;
  final Store store;

  @override
  State<AgregarTarea> createState() => _AgregarTareaState();
}

class _AgregarTareaState extends State<AgregarTarea> {
  final textController = TextEditingController();
  final tituloCOntroller = TextEditingController();
  Color bgColor = Colors.primaries.first;
  final _tareas = <Tarea>[];
  TimeOfDay time = const TimeOfDay(hour: 12, minute: 0);
  DateTime date = DateTime(2022, 11, 26);

  void _onSave() async {
    final titulo = tituloCOntroller.text.trim();
    final descripcion = textController.text.trim();
    final fecha =
        new DateTime(date.year, date.month, date.day, time.hour, time.minute);

    if (titulo.isNotEmpty && descripcion.isNotEmpty) {
      tituloCOntroller.clear();
      textController.clear();
      final tarea =
          Tarea(titulo: titulo, descripcion: descripcion, fecha: fecha);
      tarea.grupo.target = widget.grupo;
      await programarNotificacion(
          id: tarea.id, titulo: titulo, descripcion: descripcion, fecha: fecha);
      widget.store.box<Tarea>().put(tarea);
      Navigator.of(context).pop(tarea);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Nueva tarea"),
      scrollable: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Titulo",
                textAlign: TextAlign.left,
              ),
            ),
            TextField(
              controller: tituloCOntroller,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Descripcion",
                textAlign: TextAlign.left,
              ),
            ),
            TextField(
              controller: textController,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    minWidth: 30,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 24,
                            color: Colors.white,
                          ),
                          Text(
                            '${date.year}/${date.month}/${date.day}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (newDate == null) return;
                      setState(() {
                        date = newDate;
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    minWidth: 30,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 24,
                            color: Colors.white,
                          ),
                          Text(
                            '${time.hour.toString()}:${time.minute.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    onPressed: () async {
                      TimeOfDay? newTIme = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );
                      if (newTIme != null) {
                        setState(() {
                          time = newTIme;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
            color: Colors.white,
            shape: StadiumBorder(),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        MaterialButton(
          color: Color(0xFF649FF8),
          shape: StadiumBorder(),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Crear tarea',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () {
            _onSave();
          },
        ),
      ],
    );
  }
}
