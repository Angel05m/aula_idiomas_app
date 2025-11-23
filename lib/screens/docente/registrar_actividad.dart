import 'package:aula_idiomas_app/controllers/ActividadController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CrearActividadDocente extends StatefulWidget {
  const CrearActividadDocente({super.key});

  @override
  State<CrearActividadDocente> createState() => _CrearActividadDocenteState();
}

class _CrearActividadDocenteState extends State<CrearActividadDocente> {
  final ActividadController _controller = ActividadController();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  String? _selectedTipoActividad;
  final List<String> _tiposActividad = [
    'Preguntas',
    'Carga de PDF',
    'Auditiva y Oral',
  ];

  List<PreguntaWidget> preguntas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear nueva actividad',
          style: TextStyle(
            fontSize: 20,
            color: Colors.teal,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),

        backgroundColor: Colors.white,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título de la actividad:',
                    style: TextStyle(color: Color.fromARGB(184, 57, 57, 57)),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _tituloController,
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: 'Ej: Simple past vs Past Continuous',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedTipoActividad,
                    items: _tiposActividad
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedTipoActividad = val),
                    decoration: InputDecoration(
                      hintText: 'Selecciona tipo de actividad',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Descripción:',
                    style: TextStyle(color: Color.fromARGB(184, 57, 57, 57)),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _descripcionController,
                    cursorColor: Colors.teal,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Descripción de la actividad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Preguntas agregadas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            preguntas.isEmpty
                ? Container(
                    width: double.infinity,
                    height: 200,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No hay preguntas agregadas aún',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          'Presiona el botón + para agregar una',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  )
                : Column(children: preguntas.map((p) => p).toList()),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: _guardarActividad,
              child: Text(
                'Guardar Actividad',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Agregar pregunta',
        onPressed: _abrirModalAgregarPregunta,
      ),
    );
  }

  void _abrirModalAgregarPregunta() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 350,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipos de pregunta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.check_box, color: Colors.teal),
                title: Text('Opción múltiple'),
                onTap: () {
                  setState(
                    () =>
                        preguntas.add(PreguntaWidget(tipo: 'opcion_multiple')),
                  );
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.text_fields, color: Colors.blue),
                title: Text('Respuesta abierta'),
                onTap: () {
                  setState(
                    () => preguntas.add(PreguntaWidget(tipo: 'abierta')),
                  );
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.done, color: Colors.deepPurple),
                title: Text('Verdadero o Falso'),
                onTap: () {
                  setState(
                    () =>
                        preguntas.add(PreguntaWidget(tipo: 'verdadero_falso')),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _guardarActividad() async {
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _selectedTipoActividad == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Completa todos los campos')));
      return;
    }

    List<Map<String, dynamic>> preguntasJson = preguntas
        .map((p) => p.toJson())
        .toList();

    final respuesta = await _controller.guardarActividad(
      titulo: _tituloController.text,
      descripcion: _descripcionController.text,
      tipoActividad: _selectedTipoActividad!,
      preguntas: preguntasJson,
    );

    if (respuesta['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Actividad guardada exitosamente!'),
          backgroundColor: Colors.teal,
        ),
      );

      Navigator.pop(Get.context!, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(respuesta['message'])));
    }
  }
}

class PreguntaWidget extends StatefulWidget {
  final String tipo;
  PreguntaWidget({required this.tipo, super.key});

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final Map<String, TextEditingController> opcionesControllers = {
    'A': TextEditingController(),
    'B': TextEditingController(),
    'C': TextEditingController(),
    'D': TextEditingController(),
  };
  String? respuestaCorrecta;

  Map<String, dynamic> toJson() {
    switch (tipo) {
      case 'opcion_multiple':
        return {
          'tipo': tipo,
          'titulo': tituloController.text,
          'descripcion': descripcionController.text,
          'opciones': {
            'A': opcionesControllers['A']!.text,
            'B': opcionesControllers['B']!.text,
            'C': opcionesControllers['C']!.text,
            'D': opcionesControllers['D']!.text,
          },
          'respuesta_correcta': respuestaCorrecta ?? 'A',
        };
      case 'abierta':
        return {
          'tipo': tipo,
          'titulo': tituloController.text,
          'descripcion': descripcionController.text,
        };
      case 'verdadero_falso':
        return {
          'tipo': tipo,
          'titulo': tituloController.text,
          'descripcion': descripcionController.text,
          'respuesta_correcta': respuestaCorrecta ?? 'Verdadero',
        };
      default:
        return {};
    }
  }

  @override
  State<PreguntaWidget> createState() => _PreguntaWidgetState();
}

class _PreguntaWidgetState extends State<PreguntaWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.tipo[0].toUpperCase()}${widget.tipo.substring(1)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red.shade400),
                onPressed: () {
                  final parentState = context
                      .findAncestorStateOfType<_CrearActividadDocenteState>();
                  parentState?.setState(
                    () => parentState.preguntas.remove(widget),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: widget.tituloController,
            decoration: InputDecoration(
              hintText: 'Título de la pregunta',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: widget.descripcionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Descripción de la pregunta',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
            ),
          ),
          if (widget.tipo == 'opcion_multiple') ...[
            SizedBox(height: 10),
            ...['A', 'B', 'C', 'D'].map((letra) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: TextField(
                  controller: widget.opcionesControllers[letra],
                  decoration: InputDecoration(
                    labelText: 'Opción $letra',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                    ),
                  ),
                ),
              );
            }),
            DropdownButtonFormField<String>(
              value: widget.respuestaCorrecta,
              items: [
                'A',
                'B',
                'C',
                'D',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) =>
                  setState(() => widget.respuestaCorrecta = val),
              decoration: InputDecoration(
                hintText: 'Respuesta correcta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
          ],
          if (widget.tipo == 'verdadero_falso') ...[
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: widget.respuestaCorrecta,
              items: [
                'Verdadero',
                'Falso',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) =>
                  setState(() => widget.respuestaCorrecta = val),
              decoration: InputDecoration(
                hintText: 'Selecciona opción correcta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
