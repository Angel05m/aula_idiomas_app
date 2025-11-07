import 'package:aula_idiomas_app/screens/alumno/detalle_entrega_alumno.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleGrupoAlumno extends StatefulWidget {
  final Map grupo;
  final bool esPasado;

  const DetalleGrupoAlumno({
    super.key,
    required this.grupo,
    required this.esPasado,
  });

  @override
  State<DetalleGrupoAlumno> createState() => _DetalleGrupoAlumnoState();
}

class _DetalleGrupoAlumnoState extends State<DetalleGrupoAlumno> {
  bool cargando = true;
  Map<String, dynamic>? actividades;

  @override
  void initState() {
    super.initState();
    obtenerActividades();
  }

  Future<void> obtenerActividades() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final userId = prefs.getInt('userId');

    final url = Uri.parse(
      'http://127.0.0.1:8000/api/alumno/actividades-grupo/${widget.grupo['pk_grupo']}/$userId',
    );

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        actividades = data['data'];
        cargando = false;
      });
    } else {
      setState(() => cargando = false);
    }
  }

  Widget _buildSeccion(String titulo, List lista, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        iconColor: color,
        collapsedIconColor: color,
        title: Row(
          children: [
            Icon(Icons.circle, color: color, size: 10),
            const SizedBox(width: 10),
            Text(
              titulo,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: lista.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'No hay actividades en esta sección.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ]
            : lista.map((act) {
                final nombre = act['nom_actividad'] ?? 'Sin nombre';
                final fechaFin = act['fecha_fin'] ?? '';
                final fechaFormatted = fechaFin.isNotEmpty
                    ? DateFormat('dd MMM yyyy, HH:mm')
                        .format(DateTime.parse(fechaFin))
                    : 'Sin fecha límite';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.assignment, color: Colors.teal),
                    ),
                    title: Text(
                      nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha límite: $fechaFormatted',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        if (act['calificacion'] != null)
                          Text(
                            'Calificación: ${act['calificacion']}',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => DetalleEntregaAlumno(fkActividad: act['pk_actividad']),
                      ));
                    },
                  ),

                );
              }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupo = widget.grupo;
    final nombre =
        "${grupo['fk_cuatrimestre']}${grupo['nombre']}${grupo['carrera']?['abreviatura'] ?? ''} ${grupo['año']}";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(nombre),
        centerTitle: true,
        elevation: 2,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : actividades == null
              ? const Center(
                  child: Text(
                    "No se encontraron actividades del grupo.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.esPasado
                            ? "Actividades del grupo anterior"
                            : "Actividades actuales del grupo",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (!widget.esPasado) ...[
                        _buildSeccion(
                          "Pendientes",
                          actividades?['pendientes'] ?? [],
                          Colors.amber.shade700,
                        ),
                      ],
                      _buildSeccion(
                        "Entregadas",
                        actividades?['entregadas'] ?? [],
                        Colors.teal,
                      ),
                      _buildSeccion(
                        "No Entregadas",
                        actividades?['no_entregadas'] ?? [],
                        Colors.redAccent.shade200,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
