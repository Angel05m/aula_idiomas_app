import 'package:flutter/material.dart';

class DetalleEntregaAlumno extends StatelessWidget {
  final String nombreAlumno;
  final List respuestas;

  const DetalleEntregaAlumno({
    super.key,
    required this.nombreAlumno,
    required this.respuestas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreAlumno),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey.shade100,
      body: respuestas.isEmpty
          ? const Center(child: Text('El alumno no tiene respuestas registradas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: respuestas.length,
              itemBuilder: (context, index) {
                final r = respuestas[index];
                final esCorrecta = r['es_correcta'] == 1 || r['es_correcta'] == true;

                return Card(
                  color: Colors.teal.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: respuestas.map((r) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(r['pregunta'] ?? 'Pregunta desconocida'),
                            subtitle: Text(r['respuesta'] ?? ''),
                            trailing: Icon(
                              r['es_correcta'] == 1 ? Icons.check_circle : Icons.cancel,
                              color: r['es_correcta'] == 1 ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ),
                );
              },
            ),
    );
  }
}

String _formatearFecha(String? fechaIso) {
  if (fechaIso == null) return '-';
  try {
    final fecha = DateTime.parse(fechaIso).toLocal();
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return '-';
  }
}
