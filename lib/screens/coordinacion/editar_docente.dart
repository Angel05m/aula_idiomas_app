import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class EditarDocente extends StatefulWidget {
  const EditarDocente({super.key});

  @override
  State<EditarDocente> createState() => _EditarDocenteState();
}

class _EditarDocenteState extends State<EditarDocente> {
  // Variables para la seleccion en galeria y web
  //Variable para android
  File? _imagen;
  //Variable para web
  Uint8List? _imagenWeb;
  final ImagePicker _pick = ImagePicker();

  Future<void> _pickImagen(imageSource) async {
    final XFile? pickedFiel = await _pick.pickImage(source: imageSource);
    // Funciones para seleccion de web o movil
    if (pickedFiel != null) {
      if (kIsWeb) {
        final bytesWeb = await pickedFiel.readAsBytes();
        setState(() {
          _imagenWeb = bytesWeb;
        });
      } else {
        setState(() {
          _imagen = File(pickedFiel.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Docente',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Apartado para mostrar la imagen seleccionada
                  Center(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.teal,
                          child: imagenUsuario(),
                        ),
                        // { Boton para agregar una imagen }
                        TextButton(
                          onPressed: () async {
                            await _pickImagen(ImageSource.gallery);
                          },
                          child: const Text(
                            'Agregar imagen',
                            style: TextStyle(color: Colors.teal, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Nombres:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      // hintText: 'Ej: Jaruny Lupe',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Apellido Paterno:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      // hintText: 'Ej: Cárdenas',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Apellido Materno:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      // hintText: 'Ej: Tirado',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Correo:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      // hintText: 'Ej: Tirado',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: Size(double.infinity, 50),
                      elevation: 5.0,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Actualizar Información',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Apartado para mostrar la imagen seleccionada
  Widget imagenUsuario() {
    return _imagen != null
        ? ClipOval(
            child: Image.file(
              _imagen!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
        : _imagenWeb != null
        ? ClipOval(
            child: Image.memory(
              _imagenWeb!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
        : const Icon(Icons.person, size: 40, color: Colors.white);
  }
}
