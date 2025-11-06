import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'formulario_respuesta.dart';

class ResponderActividad extends StatelessWidget {
  final Map<String, dynamic> actividad;

  const ResponderActividad({
    super.key,
    required this.actividad,
  });

  @override
  Widget build(BuildContext context) {
    final nombre = actividad['nom_actividad'] ?? 'Sin nombre';
    final descripcion = actividad['descripcion'] ?? 'Sin descripción';
    final fechaFin = actividad['fecha_fin'] != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(actividad['fecha_fin']))
        : 'Sin fecha límite';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Responder actividad",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Fecha límite: $fechaFin",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormularioRespuesta(
                        idActividad: actividad['pk_actividad'],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: const Text("Responder ahora"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
