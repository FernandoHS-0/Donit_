import 'package:donit/models/grupo.dart';
import 'package:flutter/material.dart';

class AgregarGrupo extends StatefulWidget {
  const AgregarGrupo({super.key});

  @override
  State<AgregarGrupo> createState() => _AgregarGrupoState();
}

class _AgregarGrupoState extends State<AgregarGrupo> {
  Color colorSeleccionado = Colors.primaries.first;
  final textController = TextEditingController();
  String? errorMessage;

  void _onSave() {
    final name = textController.text.trim();
    if (name.isEmpty) {
      setState(() {
        errorMessage = 'El nombre es obligatorio';
      });
      return;
    } else {
      setState(() {
        errorMessage = null;
      });
    }
    final result = Grupo(nombre: name, color: colorSeleccionado.value);
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TextField(
                controller: textController,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.sentences,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    hintText: 'Nombre de la lista',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorSeleccionado,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
            ),
            SizedBox(
              height: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  errorMessage ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('Selecciona un color'),
            ),
            SizedBox(
              height: 100,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: Colors.primaries.length,
                itemBuilder: (context, index) {
                  final color = Colors.primaries[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          colorSeleccionado = color;
                          print(colorSeleccionado);
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                      ),
                    ),
                  );
                },
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
              'Crear lista',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          onPressed: _onSave,
        ),
      ],
    );
  }
}
