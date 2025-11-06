import 'package:flutter/material.dart';

class DetalleEntregaAlumno extends StatelessWidget {
  final Map<String, dynamic> actividad;

  const DetalleEntregaAlumno({
    super.key,
    required this.actividad,
  });

  @override
  Widget build(BuildContext context) {
    final entrega = actividad['entrega'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de entrega"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actividad['nom_actividad'] ?? 'Sin nombre',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Text("Calificación: ${entrega['calificacion'] ?? 'Sin calificar'}"),
            const SizedBox(height: 10),
            Text("Comentarios: ${entrega['comentarios'] ?? 'Ninguno'}"),
            const SizedBox(height: 20),
            Text("Fecha de entrega: ${entrega['fecha_entrega'] ?? '-'}"),
          ],
        ),
      ),
    );
  }
}
