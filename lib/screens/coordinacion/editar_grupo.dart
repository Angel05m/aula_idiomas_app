import 'package:flutter/material.dart';

class EditarGrupo extends StatefulWidget {
  const EditarGrupo({super.key});

  @override
  State<EditarGrupo> createState() => _EditarGrupoState();
}

class _EditarGrupoState extends State<EditarGrupo> {
  // Seccion para las opciones del select
  String? _selectedOptionGrupo;
  String? _selectedOptionCarrera;
  String? _selectedOptionCuatri;

  final List<String> _optionsGrupo = ['A', 'B', 'C'];
  final List<String> _optionsCarrera = ['Turismo', 'IDGS', 'Mecatronica'];
  final List<String> _optionsCuatri = ['1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Grupo',
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
                  Text(
                    'Nombres del grupo:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                  // Selector de grupo
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedOptionGrupo,
                    decoration: InputDecoration(
                      hintText: 'Selecciona un Grupo',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    hint: Text('', style: TextStyle(fontSize: 15.0)),
                    onChanged: (String? newValuegrupo) {
                      setState(() {
                        _selectedOptionGrupo = newValuegrupo;
                      });
                    },
                    items: _optionsGrupo.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Carrera:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  // Selector de carrera
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedOptionCarrera,
                    decoration: InputDecoration(
                      hintText: 'Selecciona una Carrera',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    hint: Text('', style: TextStyle(fontSize: 15.0)),
                    onChanged: (String? newValuecarrera) {
                      setState(() {
                        _selectedOptionCarrera = newValuecarrera;
                      });
                    },
                    items: _optionsCarrera.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Cuatrimestre:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  // Selector Cuatrimestre
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedOptionCuatri,
                    decoration: InputDecoration(
                      hintText: 'Selecciona una Cuatrimestre',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    hint: Text('', style: TextStyle(fontSize: 15.0)),
                    onChanged: (String? newValuecuatri) {
                      setState(() {
                        _selectedOptionCarrera = newValuecuatri;
                      });
                    },
                    items: _optionsCuatri.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Año:',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ej: 2025',
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
                      'Actualizar Grupo',
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
}