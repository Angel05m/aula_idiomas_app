import 'package:aula_idiomas_app/screens/coordinacion/inicio.dart';
import 'package:aula_idiomas_app/screens/coordinacion/lista-docente.dart';
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
    ListaDocente()
  ];

    final List<String> _titles = [
    'Panel Coordinador',
    'Lista de Docentes',
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
          if (_selectedIndex == 0) // solo en la página de inicio
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
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Docentes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[300],
        onTap: _onItemTapped,
      ),
    );
  }
}