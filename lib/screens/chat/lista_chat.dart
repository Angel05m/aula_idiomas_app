import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/components/usuario_chat.dart';
import 'package:flutter/material.dart';

class ListaChat extends StatefulWidget {
  const ListaChat({super.key});

  @override
  State<ListaChat> createState() => _ListaChatState();
}

class _ListaChatState extends State<ListaChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo mensaje',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.teal.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        // VISUALIZACION DEL CHAT
        child: Column(
          children: [
            InputBuscador(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                    ),
                    child: Text('Todos', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 7,),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                    ),
                    child: Text('Docente', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 7,),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                    ),
                    child: Text('Alumnos', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 17),
            Expanded(
              child: ListView(
                // LISTADO DE LOS CHAT
                children: [
                  for (int i = 1; i < 10; i++) ...[
                    UsuarioChat(
                      nombreM: 'Jaruny Cardenas Tirado',
                      tipoUsuario: 'Docente',
                    ),
                    SizedBox(height: 8.0),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
