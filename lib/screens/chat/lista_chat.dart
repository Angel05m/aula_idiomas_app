import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/components/usuario_chat.dart';
import 'package:aula_idiomas_app/models/usuario.dart';
import 'package:flutter/material.dart';

class ListaChat extends StatefulWidget {
  final List<Usuario> usuarios;

  const ListaChat({super.key, required this.usuarios});

  @override
  State<ListaChat> createState() => _ListaChatState();
}

class _ListaChatState extends State<ListaChat> {
  late List<Usuario> usuariosOriginales;
  late List<Usuario> usuariosFiltrados;

  @override
  void initState() {
    super.initState();
    usuariosOriginales = widget.usuarios;
    usuariosFiltrados = List.from(usuariosOriginales);
  }

  void buscarUsuarios(String query) {
    query = query.toLowerCase();
    setState(() {
      usuariosFiltrados = usuariosOriginales.where((u) {
        return u.nombreCompleto.toLowerCase().contains(query);
      }).toList();
    });
  }

  void filtrarPorTipo(int? tipo) {
    setState(() {
      if (tipo == null) {
        usuariosFiltrados = usuariosOriginales;
      } else {
        usuariosFiltrados = usuariosOriginales
            .where((u) => u.fkTipoUsuario == tipo)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Nuevo mensaje',
          style: TextStyle(
            fontSize: 20,
            color: Colors.teal.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
        surfaceTintColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            InputBuscador(onChanged: buscarUsuarios),
            const SizedBox(height: 10),

            Row(
              children: [
                filtroBtn("Todos", () => filtrarPorTipo(null)),
                const SizedBox(width: 7),
                filtroBtn("Docentes", () => filtrarPorTipo(2)),
                const SizedBox(width: 7),
                filtroBtn("Alumnos", () => filtrarPorTipo(1)),
              ],
            ),

            const SizedBox(height: 17),

            Expanded(
              child: usuariosFiltrados.isEmpty
                  ? const Center(child: Text("No se encontraron usuarios"))
                  : ListView.builder(
                      itemCount: usuariosFiltrados.length,
                      itemBuilder: (_, i) {
                        final u = usuariosFiltrados[i];
                        return Column(
                          children: [
                            UsuarioChat(usuario: u),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filtroBtn(String texto, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
