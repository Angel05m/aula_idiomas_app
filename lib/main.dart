import 'package:aula_idiomas_app/components/menu_cor.dart';
import 'package:aula_idiomas_app/screens/coordinacion/inicio.dart';
import 'package:aula_idiomas_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aula Idiomas',
      theme: ThemeData(primarySwatch: Colors.grey),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const Login()),
        GetPage(
          name: '/coordinacion/inicio',
          page: () => const InicioCoordinacion(),
        ),
      ],
    );
  }
}
