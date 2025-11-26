import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleEntregaAlumno extends StatefulWidget {
  final int fkActividad;

  const DetalleEntregaAlumno({
    super.key,
    required this.fkActividad,
  });

  @override
  State<DetalleEntregaAlumno> createState() => _DetalleEntregaAlumnoState();
}

class _DetalleEntregaAlumnoState extends State<DetalleEntregaAlumno> {
  Map<String, dynamic>? entrega;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEntrega();
  }

  Future<void> fetchEntrega() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final userId = prefs.getInt('userId');
    final url = Uri.parse(
      '${dotenv.env['API_URL']}${dotenv.env['API_CARGAR_ENTREGA']}/${widget.fkActividad}/$userId',
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
      if (data['success']) {
        setState(() {
          entrega = data['data'];
          isLoading = false;
        });
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final calificacion = entrega?['calificacion'];
    final comentarios = entrega?['comentarios'] ?? 'Ninguno';
    final fechaEntrega = entrega?['fecha_entrega'] ?? '-';

    IconData getEstadoIcon() {
      if (calificacion == null) return Icons.hourglass_bottom_rounded;
      if (calificacion >= 80) return Icons.emoji_events_rounded;
      if (calificacion >= 60) return Icons.check_circle_rounded;
      return Icons.error_rounded;
    }

    Color getEstadoColor() {
      if (calificacion == null) return Colors.grey;
      if (calificacion >= 80) return Colors.teal;
      if (calificacion >= 60) return Colors.orange;
      return Colors.redAccent;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Detalle de entrega", style: TextStyle(color: Colors.teal),),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.teal),
        surfaceTintColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : entrega == null
              ? const Center(
                  child: Text(
                    "No se encontró información de la entrega.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: Colors.teal.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                getEstadoIcon(),
                                size: 64,
                                color: getEstadoColor(),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                calificacion == null
                                    ? "Pendiente de calificación"
                                    : "Calificación: $calificacion",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: getEstadoColor(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Divider(color: Colors.grey.shade300),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const Icon(Icons.calendar_today_rounded,
                                    color: Colors.teal),
                                title: const Text(
                                  "Fecha de entrega",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  fechaEntrega,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.comment_rounded,
                                    color: Colors.teal),
                                title: const Text(
                                  "Comentarios del docente",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  comentarios,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text("Regresar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
