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
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: colorSeleccionado,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.group,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: 'Nombre de la lista',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          errorMessage ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Text('Selecciona un color'),
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: Colors.primaries.length,
                        itemBuilder: (context, index) {
                          final color = Colors.primaries[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  colorSeleccionado = color;
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: MaterialButton(
                        color: Colors.blue,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
