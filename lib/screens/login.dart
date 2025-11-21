import 'package:aula_idiomas_app/components/menu_al.dart';
import 'package:aula_idiomas_app/components/menu_doc.dart';
import 'package:aula_idiomas_app/controllers/AuthController.dart';
import 'package:aula_idiomas_app/screens/docente/inicio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authController = Get.put(AuthController());

  final matriculaController = TextEditingController();
  final passwordController = TextEditingController();

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
                    // Image(image: Image.asset('assets/images/logo.png'), height: 50),
                    Text(
                      'Bienvenido de nuevo',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Por favor, inicia sesión para continuar con sus actividades.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
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
                SizedBox(height: 15.0),
                Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(12.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
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

                // Recuperar contraseña
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Acción Recuperar contraseña
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
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
                        onPressed: authController.isLoadingLogin.value
                            ? null
                            : () {
                                String matricula = matriculaController.text
                                    .trim();
                                String password = passwordController.text
                                    .trim();
                                authController.login(
                                  matricula,
                                  password,
                                  context,
                                );
                              },
                        child: authController.isLoadingLogin.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45),
                          elevation: 3.0,
                        ),
                        icon: Image.asset(
                          'assets/images/google-logo.png',
                          height: 24,
                          width: 24,
                        ),
                        label: authController.isLoadingGoogle.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.teal,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Iniciar sesión con Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                        onPressed: authController.isLoadingGoogle.value
                            ? null
                            : () {
                                authController.loginWithGoogle(context);
                              },
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
