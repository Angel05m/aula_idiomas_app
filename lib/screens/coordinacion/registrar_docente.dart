import 'package:flutter/material.dart';

class RegistrarDocente extends StatefulWidget {
  const RegistrarDocente({super.key});

  @override
  State<RegistrarDocente> createState() => _RegistrarDocenteState();
}

class _RegistrarDocenteState extends State<RegistrarDocente> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Registro de usuario')
        ],
      ),
    );
  }
}