import 'dart:io';

import 'package:aula_idiomas_app/components/card-button.dart';
// import 'package:aula_idiomas_app/screens/coordinacion/lista-docente.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:get/get.dart';

class InicioCoordinacion extends StatefulWidget {
  const InicioCoordinacion({super.key});

  @override
  State<InicioCoordinacion> createState() => _InicioCoordinacionState();
}

class _InicioCoordinacionState extends State<InicioCoordinacion> {
  File? _imagen;
  final ImagePicker _pick = ImagePicker();

  Future<void> _pickImagen(ImageSource) async {
    final XFile? pickedFiel = await _pick.pickImage(source: ImageSource);

    if (pickedFiel != null) {
      setState(() {
        _imagen = File(pickedFiel.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido/a',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Coordinador/a, Jaruny Lupe Cardenas Tirado',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Center(
                child: SizedBox(
                  height: 500,
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                    ), // Elimina padding interno
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.7,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CardButton(
                        titulo: 'Docente',
                        valor: 12,
                        icono: Icons.person,
                        iconBackground: Colors.blue,
                      ),
                      CardButton(
                        titulo: 'Grupos',
                        valor: 20,
                        icono: Icons.groups,
                        iconBackground: Colors.green,
                      ),
                      CardButton(
                        titulo: 'Alumnos',
                        valor: 400,
                        icono: Icons.school,
                        iconBackground: Colors.orange,
                      ),
                      CardButton(
                        titulo: 'Accesos',
                        valor: 3,
                        icono: Icons.key,
                        iconBackground: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: _imagen != null
                        ? Image.file(_imagen!)
                        : Icon(Icons.person),
                  ),
                  TextButton(
                    onPressed: () => _pickImagen(ImageSource.gallery),
                    child: Icon(Icons.add_a_photo)
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImagen(ImageSource.camera),
                    child: Text('Tomar una foto'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
