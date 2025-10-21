import 'package:aula_idiomas_app/screens/docente/actividades.dart';
import 'package:aula_idiomas_app/screens/docente/inicio.dart';
import 'package:aula_idiomas_app/screens/docente/mis_grupos.dart';
import 'package:aula_idiomas_app/screens/docente/perfil.dart';
import 'package:flutter/material.dart';

class MenuDocente extends StatefulWidget {
  const MenuDocente({super.key});

  @override
  State<MenuDocente> createState() => _MenuDocenteState();
}

class _MenuDocenteState extends State<MenuDocente> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptionsD = <Widget>[
    InicioDocente(),
    MisGruposDocente(),
    ActividadesDocente(),
  ];

  final List<String> _titles = [
    'Panal Docente',
    'Mis Grupos',
    'Lista de Actividades',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                          builder: (context) => PerfilDocente(),
                          // PerfilAlumno()
                          // PerfilCoordinacion(),
                        ),
                      );
                      break;
                    case 'Cerrar sesión':
                      // authController.logout(context);
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
      body: _widgetOptionsD.elementAt(_selectedIndex),
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
            icon: Icon(Icons.groups, size: 30),
            label: 'Mi grupos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 30),
            label: 'Actividades',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
