import 'package:aula_idiomas_app/controllers/MisActividadesController.dart';
import 'package:aula_idiomas_app/screens/alumno/responder_actividad.dart';
import 'package:aula_idiomas_app/screens/alumno/detalle_entrega_alumno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MisActividadesAlumno extends StatefulWidget {
  const MisActividadesAlumno({super.key});

  @override
  State<MisActividadesAlumno> createState() => _MisActividadesAlumnoState();
}

class _MisActividadesAlumnoState extends State<MisActividadesAlumno> {
  final controller = MisActividadesController();
  Map<String, dynamic>? actividades;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final data = await controller.obtenerActividades();
      setState(() {
        actividades = data;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildSeccion(String titulo, List<dynamic> lista, Color color) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.circle, color: color, size: 12),
            const SizedBox(width: 10),
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 18,
              ),
            ),
          ],
        ),
        iconColor: color,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        children: lista.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'No hay actividades en esta sección.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ]
            : lista.map((act) {
                final fechaFin = act['fecha_fin'] ?? '';
                final nombre = act['nom_actividad'] ?? 'Sin nombre';
                final fechaFormatted = fechaFin.isNotEmpty
                    ? DateFormat('dd MMM yyyy, HH:mm')
                        .format(DateTime.parse(fechaFin))
                    : 'Sin fecha límite';

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.4), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.assignment, color: color, size: 24),
                    ),
                    title: Text(
                      nombre,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Fecha límite: $fechaFormatted',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 18, color: color),
                    onTap: () {
                      if (titulo.contains('Pendientes')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponderActividad(actividad: act),
                          ),
                        );
                      } else if (titulo.contains('Entregadas')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleEntregaAlumno(fkActividad: act['pk_actividad']),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Esta actividad ya no se puede entregar.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },

                  ),
                );
              }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }

    final pendientes = actividades?['pendientes'] ?? [];
    final entregadas = actividades?['entregadas'] ?? [];
    final noEntregadas = actividades?['no_entregadas'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: RefreshIndicator(
        onRefresh: cargarDatos,
        color: Colors.white,
        backgroundColor: Colors.teal,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Si en tu panel de inicio tienes actividades pendientes, verifica en la web."),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_browser),
                label: const Text("Ir a la web"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final webUrl = dotenv.env['WEB_URL'];
                  if (webUrl != null && webUrl.isNotEmpty) {
                    await launchUrl(
                      Uri.parse(webUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                }
              ),
              _buildSeccion(
                'Pendientes (${pendientes.length})',
                pendientes,
                Colors.amber.shade700,
              ),
              _buildSeccion(
                'Entregadas (${entregadas.length})',
                entregadas,
                Colors.teal,
              ),
              _buildSeccion(
                'No Entregadas (${noEntregadas.length})',
                noEntregadas,
                Colors.redAccent.shade200,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
