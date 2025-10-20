// import 'dart:typed_data';
import 'package:aula_idiomas_app/controllers/DocenteController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrarDocente extends StatefulWidget {
  const RegistrarDocente({super.key});

  @override
  State<RegistrarDocente> createState() => _RegistrarDocenteState();
}

class _RegistrarDocenteState extends State<RegistrarDocente> {
  final docenteController = Get.put(DocenteController());

  final nombresController = TextEditingController();
  final apPaternoController = TextEditingController();
  final apMaternoController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Docente',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                
                  const SizedBox(height: 10),
                  Text(
                    'Nombres:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: nombresController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Jesús Guadalupe',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Apellido Paterno:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: apPaternoController,
                    decoration: InputDecoration(
                      hintText: 'Ej: López',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Apellido Materno:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: apMaternoController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Hernández',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Correo:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Ej: correo@utescuinapa.com',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: Size(double.infinity, 50),
                      elevation: 5.0,
                    ),
                    onPressed: docenteController.isLoadingGuardar.value
                        ? null
                        : () {
                            String nombres = nombresController.text.trim();
                            String apPaterno = apPaternoController.text.trim();
                            String apMaterno = apMaternoController.text.trim();
                            String email = emailController.text.trim();
                            docenteController.guardarDocente(
                              nombres,
                              apPaterno,
                              apMaterno,
                              email,
                              context
                            );
                          },
                    child: Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
