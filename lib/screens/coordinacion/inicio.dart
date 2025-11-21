import 'dart:convert';
import 'package:aula_idiomas_app/components/card-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InicioCoordinacion extends StatefulWidget {
  const InicioCoordinacion({super.key});

  @override
  State<InicioCoordinacion> createState() => _InicioCoordinacionState();
}

class _InicioCoordinacionState extends State<InicioCoordinacion> {
  bool cargando = true;

  String ultimoMensajeTexto = '';
  String ultimoMensajeUsuario = '';
  
  int totalGrupos = 0;
  int totalDocentes = 0;
  int totalAlumnos = 0;
  int totalCoordinacion = 0;

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
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_INICIO_CORD']}/$userId'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }
      );

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        setState(() {
          totalGrupos = data['gruposCount'];
          totalDocentes = data['docentesCount'];
          totalAlumnos = data['alumnosCount'];
          totalCoordinacion = data['coordinadoresCount'];

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
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Center(
                child: SizedBox(
                  height: 500,
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                    ), // Elimina padding interno
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.7,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CardButton(
                        titulo: 'Docentes',
                        valor: totalDocentes,
                        icono: Icons.person,
                        iconBackground: Colors.blue,
                      ),
                      CardButton(
                        titulo: 'Grupos',
                        valor: totalGrupos,
                        icono: Icons.groups,
                        iconBackground: Colors.green,
                      ),
                      CardButton(
                        titulo: 'Alumnos',
                        valor: totalAlumnos,
                        icono: Icons.school,
                        iconBackground: Colors.orange,
                      ),
                      CardButton(
                        titulo: 'Coordinadores',
                        valor: totalCoordinacion,
                        icono: Icons.key,
                        iconBackground: Colors.red,
                      ),
                    ],
                  ),
                ),
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
