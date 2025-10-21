import 'package:aula_idiomas_app/components/menu_al.dart';
import 'package:aula_idiomas_app/components/menu_cor.dart';
import 'package:aula_idiomas_app/components/menu_doc.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Aula Idiomas',
      theme: ThemeData(primarySwatch: Colors.grey),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const Login()),
        GetPage(
          name: '/coordinacion/inicio',
          page: () => const MenuCoordinacion(),
        ),
        GetPage(name: '/alumno/inicio', page: () => const MenuAlumno()),
        GetPage(name: '/docente/inicio', page: () => const MenuDocente()),
      ],
    );
  }
}
