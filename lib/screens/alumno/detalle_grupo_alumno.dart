import 'package:flutter/material.dart';

class DetalleGrupoAlumno extends StatelessWidget {
  final Map grupo;

  const DetalleGrupoAlumno({super.key, required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${grupo['fk_cuatrimestre']}${grupo['nombre']} - Detalles",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Center(
        child: Text(
          "Aquí se mostrarán las actividades del grupo.",
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }
}
