import 'package:flutter/material.dart';

class ProgresoAlumno extends StatefulWidget {
  const ProgresoAlumno({super.key});

  @override
  State<ProgresoAlumno> createState() => _ProgresoAlumnoState();
}

class _ProgresoAlumnoState extends State<ProgresoAlumno> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Vista de progreso')
    );
  }
}