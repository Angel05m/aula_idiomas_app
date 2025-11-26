import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final tipo = actividad['tipo'];
    
    final fechaFin = actividad['fecha_fin'] != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(actividad['fecha_fin']))
        : 'Sin fecha límite';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.teal),
        title: const Text(
          "Responder actividad",
          style: TextStyle(color: Colors.teal),
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
              style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 62, 62, 62)),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (tipo == "preguntas") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormularioRespuesta(
                          idActividad: actividad['pk_actividad'],
                        ),
                      ),
                    );
                  } else {
                    final webUrl = dotenv.env['WEB_URL'];
                    if (webUrl != null && webUrl.isNotEmpty) {
                      launchUrl(
                        Uri.parse(webUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
                icon: Icon(
                  tipo == "preguntas" ? Icons.upload_file : Icons.link,
                ),
                label: Text(
                  tipo == "preguntas" ? "Responder ahora" : "Abrir sitio web",
                ),
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
