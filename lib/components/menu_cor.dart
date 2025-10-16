import 'package:aula_idiomas_app/screens/coordinacion/inicio.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista_grupos.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista_alumnos.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista_docente.dart';
import 'package:flutter/material.dart';

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
                Icon(Icons.notifications, size: 33, color: Colors.black),
                SizedBox(width: 10),
                CircleAvatar(radius: 22),
                SizedBox(width: 10),
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
            icon: Icon(Icons.school, size: 30,),
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