import 'package:flutter/material.dart';

class CrearActividadDocente extends StatefulWidget {
  const CrearActividadDocente({super.key});

  @override
  State<CrearActividadDocente> createState() => _CrearActividadDocenteState();
}

class _CrearActividadDocenteState extends State<CrearActividadDocente> {
  // LISTA DE FORMULARIO DINAICO
  List<Widget> preguntas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear nueva actividad',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FORMULARIO PRINCIPAL
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1, color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Título de la actividad:'),
                  SizedBox(height: 5),
                  // INPUT DE TITULO DE ACTIVIDAD
                  TextField(
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: 'Ej: Simple past vs Past Continuous',
                      hintStyle: TextStyle(fontSize: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Descripción:'),
                  SizedBox(height: 5),
                  // INPUT DE DESCRIPCION
                  TextField(
                    cursorColor: Colors.teal,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Ej: Actividad sobre tiempos verbales',
                      hintStyle: TextStyle(fontSize: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
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
            // LISTA DE PREGUNTAS
            preguntas.isEmpty
                ? Container(
                    width: double.infinity,
                    height: 300,
                    padding: EdgeInsets.symmetric(vertical: 30),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No hay preguntas agregadas aún',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Presiona el botón + para agregar una',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(children: preguntas),
          ],
        ),
      ),
      // BOTON FLOTANTE
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Agregar pregunta',
        onPressed: _abrirModal,
      ),
    );
  }

  // FUNCION PARA ABRIR EL MODAL
  void _abrirModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tipos de pregunta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // BOTON PARA AGREGAR PREGUNTA DE OPCION MULTIPLE
              ListTile(
                leading: Icon(Icons.check_box_outlined, color: Colors.teal),
                title: Text('Opción múltiple'),
                onTap: () {
                  setState(() {
                    preguntas.add(_PreguntaOpcionMultiple(preguntas.length));
                  });
                  // CERRAR EL MODAL
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.text_fields_outlined, color: Colors.blue),
                title: Text('Respuesta abierta'),
                onTap: () {
                  setState(() {
                    preguntas.add(_preguntaAbierta(preguntas.length));
                  });
                  Navigator.pop(context);
                  // Aquí puedes agregar otros tipos de preguntas en el futuro
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // METODO QUE GENERE UNA PREGUNTA DE TIPO OPCIONAL
  Widget _PreguntaOpcionMultiple(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1, color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENCABEZADO CON BOTON DE ELIMINAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ENCABEZADO
                    Text(
                      'Pregunta ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Opción multiple',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // BOTON PARA ELIMINAR PREGUNTA
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    if (index >= 0 && index < preguntas.length) {
                      setState(() {
                        preguntas.removeAt(index);
                      });
                    }
                  },
                  icon: Icon(Icons.close, color: Colors.red.shade400),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('Título de la pregunta:'),
          SizedBox(height: 5),
          TextField(
            cursorColor: Colors.teal,
            decoration: InputDecoration(
              hintText: 'Ej: Simple past vs Past Continuous',
              hintStyle: TextStyle(fontSize: 14.0),
              contentPadding: EdgeInsets.all(7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.teal, width: 3.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Respuestas:'),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                // INPUT DE RESPUESTA A
                TextField(
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Respuesta A',
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Ej: Respuesta A',
                    hintStyle: TextStyle(fontSize: 14.0),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                    contentPadding: EdgeInsets.all(7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                // INPUT DE RESPUESTA B
                TextField(
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Respuesta B',
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Ej: Respuesta B',
                    hintStyle: TextStyle(fontSize: 14.0),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                    contentPadding: EdgeInsets.all(7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                // INPUT DE RESPUESTA C
                TextField(
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Respuesta C',
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Ej: Respuesta C',
                    hintStyle: TextStyle(fontSize: 14.0),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                    contentPadding: EdgeInsets.all(7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                // INPUT DE RESPUESTA D
                TextField(
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Respuesta D',
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Ej: Respuesta D',
                    hintStyle: TextStyle(fontSize: 14.0),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                    contentPadding: EdgeInsets.all(7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                // INPUT DE OPCION CORRECTA
                child: TextField(
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Opción correcta',
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Ej: Respuesta A',
                    hintStyle: TextStyle(fontSize: 14.0),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                // INPUT PARA AGREGAR UN VALOR
                child: TextField(
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Pts: 10',
                    hintStyle: TextStyle(fontSize: 14.0),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal, width: 3.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // FORMULARIO DE PREGUNTA ABIERTA
  Widget _preguntaAbierta(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1, color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ENCABEZADO
                    Text(
                      'Pregunta ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Abierta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // BOTON PARA ELIMINAR PREGUNTA
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    if (index >= 0 && index < preguntas.length) {
                      setState(() {
                        preguntas.removeAt(index);
                      });
                    }
                  },
                  icon: Icon(Icons.close, color: Colors.red.shade400),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('Título de la pregunta:'),
          SizedBox(height: 5),
          // INPUT DEL TITULO DE LA PREGUNTA ABIERTA
          TextField(
            cursorColor: Colors.teal,
            decoration: InputDecoration(
              hintText: 'Ej: Discription the function from Past Simple',
              hintStyle: TextStyle(fontSize: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.teal, width: 3.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Descripción:'),
          SizedBox(height: 5),
          // INPUT DE DESCRIPCION
          TextField(
            cursorColor: Colors.teal,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Ej: Describir la actividad',
              hintStyle: TextStyle(fontSize: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.teal, width: 3.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
