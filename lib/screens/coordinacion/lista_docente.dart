import 'package:aula_idiomas_app/components/card_info_docente.dart';
import 'package:aula_idiomas_app/controllers/DocenteController.dart';
import 'package:aula_idiomas_app/controllers/ListaDocenteController.dart';
import 'package:aula_idiomas_app/screens/coordinacion/editar_docente.dart';
import 'package:aula_idiomas_app/screens/coordinacion/registrar_docente.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaDocente extends StatefulWidget {
  const ListaDocente({super.key});

  @override
  State<ListaDocente> createState() => _ListaDocenteState();
}

class _ListaDocenteState extends State<ListaDocente> {
  final listaDocenteController = Get.put(ListaDocenteController());
  final docenteController = Get.put(DocenteController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listaDocenteController.fetchDocentes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !listaDocenteController.isLoadingMore.value &&
          listaDocenteController.hasMore.value) {
        listaDocenteController.fetchDocentes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (listaDocenteController.isLoading.value &&
            listaDocenteController.docentes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final docentes = listaDocenteController.docentes;

        return RefreshIndicator(
          onRefresh: () async {
            await listaDocenteController.refreshDocentes();
          },
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 10),
              const Text(
                'Docentes',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                'Añade, edita y gestiona la información de los docentes',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar docente por nombre o correo...',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(width: 1.0),
                  ),
                ),
                onSubmitted: (value) {
                  listaDocenteController.searchDocentes(value.trim());
                },
              ),
              const SizedBox(height: 20),

              if (docentes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'No se encontraron docentes.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              else
                ...docentes.map<Widget>((docente) {
                  final nombreCompleto =
                      '${docente['nombres'] ?? ''} ${docente['ap_paterno'] ?? ''} ${docente['ap_materno'] ?? ''}'
                          .trim();

                  final bool isActive = docente['deleted_at'] == null;

                  return CardInfoDocente(
                    idDocente: docente['pk_usuario'],
                    nombre: nombreCompleto,
                    correo: docente['email'] ?? 'Sin correo',
                    isActive: isActive,
                  );
                }).toList(),

              if (listaDocenteController.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarDocente()),
          );

          if (result == true) {
            await listaDocenteController.refreshDocentes();
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.person_add, color: Colors.white),
        tooltip: 'Agregar nuevo docente',
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
