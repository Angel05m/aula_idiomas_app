import 'package:aula_idiomas_app/controllers/AuthController.dart';
import 'package:aula_idiomas_app/screens/alumno/inicio.dart';
import 'package:aula_idiomas_app/screens/alumno/mis_actividades.dart';
import 'package:aula_idiomas_app/screens/alumno/perfil.dart';
import 'package:aula_idiomas_app/screens/alumno/progreso.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuAlumno extends StatefulWidget {
  const MenuAlumno({super.key});

  @override
  State<MenuAlumno> createState() => _MenuAlumnoState();
}

class _MenuAlumnoState extends State<MenuAlumno> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptionsA = <Widget>[
    InicioAlumnos(),
    MisActividadesAlumno(),
    ProgresoAlumno(),
  ];

  final List<String> _titles = ['Panal Alumno', 'Mis Actividades', 'Progreso'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Icon(Icons.notifications, size: 30, color: Colors.black),
              SizedBox(width: 5),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 30, color: Colors.black),
                onSelected: (String resultado) {
                  switch (resultado) {
                    case 'Perfil':
                      // Navegación
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerfilAlumno(),
                          // PerfilAlumno()
                          // PerfilCoordinacion(),
                        ),
                      );
                      break;
                    case 'Cerrar sesión':
                      authController.logout(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Perfil',
                    child: Text('Perfil'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Cerrar sesión',
                    child: Text('Cerrar sesión'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptionsA.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 30),
            label: 'Mis Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.short_text, size: 30),
            label: 'Progreso',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
