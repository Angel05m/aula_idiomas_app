import 'package:aula_idiomas_app/screens/docente/detalle_entrega_alumno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleActividad extends StatefulWidget {
  final int pkActividad;
  final String nombreActividad;

  const DetalleActividad({
    super.key,
    required this.pkActividad,
    required this.nombreActividad,
  });

  @override
  State<DetalleActividad> createState() => _DetalleActividadState();
}

class _DetalleActividadState extends State<DetalleActividad> {
  bool cargando = true;
  List entregas = [];
  List noEntregados = [];

  @override
  void initState() {
    super.initState();
    obtenerDetalleActividad();
  }

  Future<void> obtenerDetalleActividad() async {
    setState(() => cargando = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final res = await http.get(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_OBTENER_DETALLE_ACTIVIDAD']}/${widget.pkActividad}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success']) {
          setState(() {
            entregas = data['data']['entregas'] ?? [];
            noEntregados = data['data']['no_entregados'] ?? [];
            cargando = false;
          });
        } else {
          setState(() => cargando = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Error al cargar entregas')),
          );
        }
      } else {
        setState(() => cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al obtener detalles de la actividad")),
        );
      }
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreActividad),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey.shade100,
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Entregas realizadas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  entregas.isEmpty
                      ? const Text('Ningún alumno ha entregado aún.')
                      : Column(
                          children: entregas.map((entrega) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.check_circle, color: Colors.green),
                                title: Text(entrega['nombre_completo'] ?? 'Alumno desconocido'),
                                subtitle: Text(
                                  'Fecha de entrega: ${_formatearFecha(entrega['respuestas'] != null && entrega['respuestas'].isNotEmpty ? entrega['respuestas'][0]['created_at'] : null)}',
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalleEntregaAlumno(
                                        nombreAlumno: entrega['nombre_completo'] ?? 'Alumno desconocido',
                                        respuestas: entrega['respuestas'] ?? [],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),
                  const Text(
                    'Alumnos sin entrega',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  noEntregados.isEmpty
                      ? const Text('Todos los alumnos han entregado.')
                      : Column(
                          children: noEntregados.map((alumno) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.person_outline, color: Colors.grey),
                                title: Text(alumno['nombre_completo'] ?? 'Alumno desconocido'),
                                subtitle: const Text('No ha entregado aún'),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
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

