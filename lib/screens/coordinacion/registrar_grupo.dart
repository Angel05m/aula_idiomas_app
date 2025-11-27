import 'dart:convert';
import 'package:aula_idiomas_app/controllers/GrupoCoordinadorController.dart';
import 'package:aula_idiomas_app/controllers/ListaGruposController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrarGrupo extends StatefulWidget {
  final ListaGruposController listaGruposController;

  const RegistrarGrupo({super.key, required this.listaGruposController});

  @override
  State<RegistrarGrupo> createState() => _RegistrarGrupoState();
}

class _RegistrarGrupoState extends State<RegistrarGrupo> {
  final _anioController = TextEditingController();

  String? _selectedOptionGrupo;
  String? _selectedOptionCarrera;
  String? _selectedOptionCuatri;
  String? _selectedOptionMateria;
  String? _selectedOptionDocente;

  List<dynamic> carreras = [];
  List<dynamic> materias = [];
  List<dynamic> docentes = [];

  final List<String> _optionsGrupo = ['A', 'B', 'C', 'D', 'F'];
  final List<String> _optionsCuatri = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];

  late GrupoCoordinadorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GrupoCoordinadorController(
      listaGruposController: widget.listaGruposController,
    );
    fetchDataForm();
  }

  Future<void> fetchDataForm() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_DATA_GRUPO']}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            carreras = data['carreras'];
            materias = data['materias'];
            docentes = data['docentes'];
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar datos del formulario'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _crearGrupo() async {
    if (_selectedOptionGrupo == null ||
        _selectedOptionCarrera == null ||
        _selectedOptionCuatri == null ||
        _selectedOptionMateria == null ||
        _selectedOptionDocente == null ||
        _anioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await _controller.crearGrupo(
      context: context,
      nombre: _selectedOptionGrupo!,
      anio: _anioController.text,
      fkCarrera: _selectedOptionCarrera!,
      fkCuatrimestre: _selectedOptionCuatri!,
      fkMateria: _selectedOptionMateria!,
      fkDocente: _selectedOptionDocente!,
    );
  }

  @override
  void dispose() {
    _anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Grupo',
          style: TextStyle(
            fontSize: 25,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              label: 'Nombre del grupo:',
              value: _selectedOptionGrupo,
              hint: 'Selecciona un Grupo',
              items: _optionsGrupo,
              onChanged: (val) => setState(() => _selectedOptionGrupo = val),
            ),
            const SizedBox(height: 10.0),
            _buildDropdownFromData(
              label: 'Carrera:',
              value: _selectedOptionCarrera,
              hint: 'Selecciona una Carrera',
              data: carreras,
              displayField: 'nombre',
              idField: 'pk_carrera',
              onChanged: (val) => setState(() => _selectedOptionCarrera = val),
            ),
            const SizedBox(height: 10.0),
            _buildDropdownFromData(
              label: 'Materia:',
              value: _selectedOptionMateria,
              hint: 'Selecciona una Materia',
              data: materias,
              displayField: 'nombre',
              idField: 'pk_materia',
              onChanged: (val) => setState(() => _selectedOptionMateria = val),
            ),
            const SizedBox(height: 10.0),
            _buildDropdownFromData(
              label: 'Docente:',
              value: _selectedOptionDocente,
              hint: 'Selecciona un Docente',
              data: docentes,
              displayField: null,
              idField: 'pk_usuario',
              customDisplay: (d) =>
                  '${d['nombres'] ?? ''} ${d['ap_paterno'] ?? ''} ${d['ap_materno'] ?? ''}'
                      .trim(),
              onChanged: (val) => setState(() => _selectedOptionDocente = val),
            ),
            const SizedBox(height: 10.0),
            _buildDropdown(
              label: 'Cuatrimestre:',
              value: _selectedOptionCuatri,
              hint: 'Selecciona un Cuatrimestre',
              items: _optionsCuatri,
              onChanged: (val) => setState(() => _selectedOptionCuatri = val),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Año:',
              style: TextStyle(
                fontSize: 15.0,
                color: Color.fromARGB(184, 57, 57, 57),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5.0),
            TextField(
              controller: _anioController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Ej: 2025'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5.0,
              ),
              onPressed: _crearGrupo,
              child: const Text(
                'Crear Grupo',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(184, 57, 57, 57),
            fontSize: 15.0,
          ),
        ),
        const SizedBox(height: 5.0),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: _inputDecoration(hint),
          onChanged: onChanged,
          items: items
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownFromData({
    required String label,
    required String hint,
    required List<dynamic> data,
    required String idField,
    String? displayField,
    String? value,
    required Function(String?) onChanged,
    String Function(dynamic)? customDisplay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(184, 57, 57, 57),
          ),
        ),
        const SizedBox(height: 5.0),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: _inputDecoration(hint),
          onChanged: onChanged,
          items: data.map((item) {
            final text = customDisplay != null
                ? customDisplay(item)
                : item[displayField] ?? 'Sin nombre';
            return DropdownMenuItem<String>(
              value: item[idField].toString(),
              child: Text(text),
            );
          }).toList(),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: Colors.white,
    prefixIconColor: Colors.teal,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(width: 1.0, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.teal, width: 3.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );
}
