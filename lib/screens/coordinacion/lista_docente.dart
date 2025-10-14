import 'package:aula_idiomas_app/components/card_info_docente.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/screens/coordinacion/registrar_docente.dart';
import 'package:flutter/material.dart';

class ListaDocente extends StatefulWidget {
  const ListaDocente({super.key});

  @override
  State<ListaDocente> createState() => _ListaDocenteState();
}

class _ListaDocenteState extends State<ListaDocente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Docentes',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Añade, edita y gestiona la información de los docentes',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const InputBuscador(),
              const SizedBox(height: 13.0),
              Column(
                children: const [
                  CardInfoDocente(
                    nombre: 'Jaruny Cardenas Tirado',
                    correo: 'jaruny@gmail.com',
                  ),
                  CardInfoDocente(
                    nombre: 'Melissa Cardenas',
                    correo: 'melissa@gmail.com',
                  ),
                  CardInfoDocente(
                    nombre: 'Paty Scalante',
                    correo: 'paty@gmail.com',
                  ),
                  CardInfoDocente(
                    nombre: 'Roberto Rojas',
                    correo: 'roberto.rojas@gmail.com',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarDocente()));
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.person_add, color: Colors.white),
        tooltip: 'Agregar nuevo docente',
        elevation: 5,
      ),
      // Boton flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
