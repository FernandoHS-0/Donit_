import 'package:donit/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:donit/models/grupo.dart';
import 'package:donit/pages/AgregarGrupo.dart';
import 'package:donit/pages/Tareas.dart';
import 'package:objectbox/objectbox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _grupos = <Grupo>[];
  late final Store _store;
  late final Box<Grupo> _groupsBox;

  Future<void> _agregarGrupo() async {
    final resultado = await showDialog(
      context: context,
      builder: (_) => const AgregarGrupo(),
    );

    if (resultado != null && resultado is Grupo) {
      _groupsBox.put(resultado);
      _loadGroups();
    }
  }

  void _loadGroups() {
    _grupos.clear();
    setState(() {
      _grupos.addAll(_groupsBox.getAll());
    });
  }

  Future<void> _loadStore() async {
    _store = await openStore();
    _groupsBox = _store.box<Grupo>();
    _loadGroups();
  }

  Future<void> _irTarea(Grupo grupo) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Tareas(grupo: grupo, store: _store),
      ),
    );

    _loadGroups();
  }

  @override
  void initState() {
    _loadStore();
    super.initState();
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donit"),
      ),
      body: _grupos.isEmpty
          ? const Center(
              child: Text("No hay ninguna lista"),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _grupos.length,
              itemBuilder: (context, index) {
                final grupo = _grupos[index];
                return _ItemGrupo(
                  onTap: () => _irTarea(grupo),
                  grupo: grupo,
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("+"),
        backgroundColor: Color(0xFF649FF8),
        onPressed: _agregarGrupo,
      ),
    );
  }
}

class _ItemGrupo extends StatelessWidget {
  _ItemGrupo({
    Key? key,
    required this.grupo,
    required this.onTap,
  }) : super(key: key);

  final Grupo grupo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final descripcion = grupo.descripcionDeTarea();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(grupo.color),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                grupo.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              if (descripcion.isNotEmpty) ...[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  descripcion,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
