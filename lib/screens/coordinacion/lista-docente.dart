import 'package:flutter/material.dart';

class ListaDocente extends StatefulWidget {
  const ListaDocente({super.key});

  @override
  State<ListaDocente> createState() => _ListaDocenteState();
}

class _ListaDocenteState extends State<ListaDocente> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text('Lista Docente'),
      ),
    );
  }
}