import 'dart:convert';

import 'package:aula_idiomas_app/components/card-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InicioDocente extends StatefulWidget {
  const InicioDocente({super.key});

  @override
  State<InicioDocente> createState() => _InicioDocenteState();
}

class _InicioDocenteState extends State<InicioDocente> {
  bool cargando = true;

  String ultimoMensajeTexto = '';
  String ultimoMensajeUsuario = '';
  final usuario = [];
  
  int totalGrupos = 0;
  int totalActividades = 0;
  int totalAlumnos = 0;
  int totalActividadesRevision = 0;

  @override
  void initState(){
    super.initState();
    cargarPanel();
  }

   Future<void> cargarPanel() async {
    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final userId = prefs.getInt('userId') ?? 0;

    try {
      final res = await http.get(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_INICIO_DOCE']}/$userId'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }
      );

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        setState(() {
          totalGrupos = data['gruposCount'];
          totalActividades = data['actividadesCount'];
          totalAlumnos = data['alumnosCount'];
          totalActividadesRevision = data['actividadesRevisionCount'];

          final ultimo = data['ultimoMensaje'];
          if (ultimo != null) {
            ultimoMensajeTexto = ultimo['mensaje'] ?? '';
            final deUsuario = ultimo['de_usuario'];
            if (deUsuario != null) {
              ultimoMensajeUsuario =
                  '${deUsuario['nombres']} ${deUsuario['ap_paterno'] ?? ''}';
            }
          }

          cargando = false;
        });
      }else{
        setState(() => cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar panel (${res.statusCode})')),
        );
      }
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido/a',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Docente, Melissa Sas Perez',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Actividades',
                      valor: totalActividades,
                      icono: Icons.assignment,
                      iconBackground: Colors.lightGreen,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Actividades Pendientes',
                      valor: totalActividadesRevision,
                      icono: Icons.access_time,
                      iconBackground: Colors.red.shade300
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Grupos Asignados',
                      valor: totalGrupos,
                      icono: Icons.done,
                      iconBackground: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Alumnos en Docencia',
                      valor: totalAlumnos,
                      icono: Icons.assignment_turned_in,
                      iconBackground: Colors.deepOrangeAccent.shade400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                "Último mensaje recibido: ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),
              const SizedBox(height: 10),
              if (ultimoMensajeTexto.isNotEmpty)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$ultimoMensajeUsuario dice...",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"$ultimoMensajeTexto"',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Text("No hay mensajes recientes")
            ],
          ),
        ),
      ),
    );
  }
}
