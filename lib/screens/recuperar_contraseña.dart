import 'package:aula_idiomas_app/components/menu_al.dart';
import 'package:aula_idiomas_app/components/menu_doc.dart';
import 'package:aula_idiomas_app/controllers/AuthController.dart';
import 'package:aula_idiomas_app/screens/docente/inicio.dart';
import 'package:aula_idiomas_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  State<RecuperarContrasena> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final authController = Get.put(AuthController());

  final matriculaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '¿Quieres recuperar tu contraseña?',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Por favor, ingresa tu matrícula para recuperar tu contraseña.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),

                Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: TextField(
                    controller: matriculaController,
                    decoration: InputDecoration(
                      hintText: 'Matricula',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      '¿Quieres iniciar sesión?',
                      style: TextStyle(color: Colors.teal[600]),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                Obx(() {
                  return Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size(double.infinity, 45),
                          elevation: 5.0,
                        ),
                        onPressed: authController.isLoadingRecovery.value
                            ? null
                            : () {
                                String matricula = matriculaController.text
                                    .trim();
                                authController.recovery(
                                  matricula,
                                  context,
                                );
                              },
                        child: authController.isLoadingRecovery.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Recuperar contraseña',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
