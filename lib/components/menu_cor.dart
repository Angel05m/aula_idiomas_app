import 'package:aula_idiomas_app/screens/alumno/perfil.dart';
import 'package:aula_idiomas_app/screens/chat/inicio_chat.dart';
import 'package:aula_idiomas_app/screens/coordinacion/inicio.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista_grupos.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista_alumnos.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista_docente.dart';
import 'package:aula_idiomas_app/screens/coordinacion/perfil.dart';
import 'package:aula_idiomas_app/screens/docente/perfil.dart';
import 'package:aula_idiomas_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:aula_idiomas_app/controllers/AuthController.dart';
import 'package:get/get.dart';

class MenuCoordinacion extends StatefulWidget {
  const MenuCoordinacion({super.key});

  @override
  State<MenuCoordinacion> createState() => _MenuCoordinacionState();
}

class _MenuCoordinacionState extends State<MenuCoordinacion> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    InicioCoordinacion(),
    ListaDocente(),
    ListaGrupos(),
    ListaAlumnos(),
  ];

  final List<String> _titles = [
    'Panel Coordinador',
    'Lista de Docentes',
    'Lista de Grupos',
    'Lista de Alumnos',
  ];

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
          style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InicioChat(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.message,
                  size: 30,
                  color: Colors.grey.shade600,
                ),
              ),
              // Icon(Icons.notifications, size: 30, color: Colors.black),
              SizedBox(width: 5),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 30, color: Colors.grey.shade600),
                onSelected: (String resultado) {
                  switch (resultado) {
                    case 'Perfil':
                      // Navegación
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerfilCoordinacion(),
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
      body: _widgetOptions.elementAt(_selectedIndex),
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
            icon: Icon(Icons.person, size: 30),
            label: 'Docentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups, size: 30),
            label: 'Grupos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: 30),
            label: 'Alumnos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
