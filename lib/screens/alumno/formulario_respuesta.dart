import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormularioRespuesta extends StatefulWidget {
  final int idActividad;

  const FormularioRespuesta({super.key, required this.idActividad});

  @override
  State<FormularioRespuesta> createState() => _FormularioRespuestaState();
}

class _FormularioRespuestaState extends State<FormularioRespuesta> {
  Map<String, dynamic>? actividad;
  bool cargando = true;

  final Map<int, dynamic> respuestas = {};

  @override
  void initState() {
    super.initState();
    fetchActividad();
  }

  Future<void> fetchActividad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final url = Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_RESPONDER_ACTIVIDAD']}/${widget.idActividad}');
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final act = data['actividad']; 

        setState(() {
          actividad = act;
          cargando = false;
        });
      } else {
        throw Exception('Error al obtener la actividad');
      }
    } catch (e) {
      print('Error al cargar actividad: $e');
      setState(() {
        cargando = false;
      });
    }
  }

  void enviarRespuestas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final userId = prefs.getInt('userId');

    final List<Map<String, dynamic>> listaRespuestas = respuestas.entries.map((e) {
      return {
        'fk_pregunta': e.key,
        'respuesta': e.value.toString(),
      };
    }).toList();

    final body = {
      'fk_actividad': widget.idActividad,
      'fk_alumno': userId,
      'respuestas': listaRespuestas,
    };

    print("📦 Enviando:");
    print(jsonEncode({
      'fk_actividad': widget.idActividad,
      'fk_alumno': userId,
      'respuestas': listaRespuestas,
    }));

    final url = Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_RESPONDER']}');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Respuestas enviadas correctamente"), backgroundColor: Colors.teal,),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data['message']}")),
        );
      }
    } else {
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al enviar las respuestas")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (actividad == null) {
      return const Scaffold(
        body: Center(child: Text('No se pudo cargar la actividad')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(actividad!['nom_actividad'] ?? 'Responder actividad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actividad!['descripcion'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 25),
            ..._buildPreguntas(actividad!['preguntas']),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: enviarRespuestas,
                icon: const Icon(Icons.send),
                label: const Text("Enviar respuestas"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPreguntas(List<dynamic> preguntas) {
    return preguntas.map((pregunta) {
      final pk = pregunta['pk_pregunta'];
      final tipo = pregunta['tipo'];
      final opciones = pregunta['opciones'] as List<dynamic>;

      return Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pregunta['pregunta'] ?? 'Sin texto',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            if (pregunta['descripcion'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  pregunta['descripcion'],
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 12),

            if (tipo == 'opcion_multiple')
              ...opciones.map((op) {
                return RadioListTile<String>(
                  title: Text(op['texto_opcion']),
                  value: op['texto_opcion'],
                  groupValue: respuestas[pk],
                  onChanged: (value) {
                    setState(() {
                      respuestas[pk] = value;
                    });
                  },
                );
              }).toList(),

            if (tipo == 'abierta')
              TextField(
                decoration: InputDecoration(
                  hintText: 'Escribe tu respuesta aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  respuestas[pk] = value;
                },
              ),
          ],
        ),
      );
    }).toList();
}

}
