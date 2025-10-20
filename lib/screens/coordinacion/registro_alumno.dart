import 'dart:convert';
import 'package:aula_idiomas_app/controllers/AlumnosController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class Grupo {
  final int id;
  final String nombre;
  final String? abreviaturaCarrera;
  final int? numCuatrimestre;
  final int? anio;

  Grupo({
    required this.id,
    required this.nombre,
    this.abreviaturaCarrera,
    this.numCuatrimestre,
    this.anio,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: int.tryParse(json['id']?.toString() ?? json['pk_grupo']?.toString() ?? '0') ?? 0,
      nombre: json['nombre'] ?? '',
      abreviaturaCarrera: json['carrera']?['abreviatura'],
      numCuatrimestre: int.tryParse(json['cuatrimestre']?['num_cuatri']?.toString() ?? ''),
      anio: int.tryParse(json['año']?.toString() ?? json['anio']?.toString() ?? ''),
    );
  }
}

class RegistroAlumno extends StatefulWidget {
  const RegistroAlumno({super.key});

  @override
  State<RegistroAlumno> createState() => _RegistroAlumnoState();
}

class _RegistroAlumnoState extends State<RegistroAlumno> {

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apPaternoController = TextEditingController();
  final TextEditingController _apMaternoController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();

  String? _selectedGrupo;
  late Future<List<Grupo>> _gruposFuture;
  final alumnoController = Get.put(AlumnosController());


  @override
  void initState() {
    super.initState();
    _gruposFuture = fetchGrupos();
  }

  Future<List<Grupo>> fetchGrupos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) throw Exception('Token no encontrado');

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/coordinacion/formulario-alumno'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List gruposData = data['data'];
      return gruposData.map((e) => Grupo.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener los grupos');
    }
  }

  Future<void> registrarAlumno() async {
    if (_selectedGrupo == null ||
        _nombreController.text.isEmpty ||
        _apPaternoController.text.isEmpty ||
        _matriculaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final body = {
      'nombres': _nombreController.text,
      'ap_paterno': _apPaternoController.text,
      'ap_materno': _apMaternoController.text,
      'matricula': _matriculaController.text,
      'fk_grupo': _selectedGrupo,
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/coordinacion/alumno/guardar'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alumno registrado exitosamente'),
            backgroundColor: Colors.teal,
          ),
        );
        alumnoController.refresh();
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${data['message']}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar el alumno'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Variables para la seleccion en galeria y web
  File? _imagen;
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
        title: const Text(
          'Registrar Alumno',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      //       backgroundColor: Colors.grey.shade100,
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            campoTexto('Nombres:', _nombreController, 'Ej: Juan Carlos'),
            campoTexto('Apellido Paterno:', _apPaternoController, 'Ej: López'),
            campoTexto('Apellido Materno:', _apMaternoController, 'Ej: Hernández'),
            campoTexto('Matrícula:', _matriculaController, 'Ej: 202500001'),

            const SizedBox(height: 10.0),
            const Text(
              'Grupo:',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 5.0),

            FutureBuilder<List<Grupo>>(
              future: _gruposFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.teal),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay grupos disponibles');
                }

                final grupos = snapshot.data!;
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedGrupo,
                  decoration: InputDecoration(
                    hintText: 'Selecciona un Grupo',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(width: 1.0, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrupo = newValue;
                    });
                  },
                  items: grupos.map((grupo) {
                    final texto =
                        "${grupo.numCuatrimestre ?? 'Sin cuatri'}°${grupo.nombre} - "
                        "${grupo.abreviaturaCarrera ?? 'Sin carrera'} - ${grupo.anio ?? ''}";
                    return DropdownMenuItem<String>(
                      value: grupo.id.toString(),
                      child: Text(texto, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5.0,
              ),
              onPressed: registrarAlumno,
              child: const Text(
                'Registrar Alumno',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campoTexto(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15.0)),
          const SizedBox(height: 5.0),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 3.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
