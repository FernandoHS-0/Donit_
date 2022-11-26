import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:donit/models/grupo.dart';
import 'package:donit/objectbox.g.dart';
import 'package:donit/models/tarea.dart';

class AgregarTarea extends StatefulWidget {
  const AgregarTarea({super.key});

  @override
  State<AgregarTarea> createState() => _AgregarTareaState();
}

class _AgregarTareaState extends State<AgregarTarea> {
  final textController = TextEditingController();
  Color bgColor = Colors.primaries.first;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Nueva tarea"),
      scrollable: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2.2,
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
              controller: textController,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 0,
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
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 0,
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    minWidth: 30,
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 24,
                            color: Colors.white,
                          ),
                          Text(
                            'Fecha',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    onPressed: () {},
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    minWidth: 30,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.lock_clock,
                            size: 24,
                            color: Colors.white,
                          ),
                          Text(
                            'Hora',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    onPressed: () {},
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
          color: Colors.blue,
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
          onPressed: () {},
        ),
      ],
    );
  }
}
