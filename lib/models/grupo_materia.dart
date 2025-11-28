import 'dart:convert';

class GrupoMateria {
  final int pkGrupoMateria;
  final Grupo? grupo;
  final Materia materia;

  GrupoMateria({
    required this.pkGrupoMateria,
    required this.grupo,
    required this.materia,
  });

  factory GrupoMateria.fromJson(Map<String, dynamic> json) {
    return GrupoMateria(
      pkGrupoMateria: json['pk_grupo_materia'],
      grupo: json['grupo'] != null ? Grupo.fromJson(json['grupo']) : null,
      materia: Materia.fromJson(json['materia']),
    );
  }
}

class Grupo {
  final int pkGrupo;
  final String nombre;
  final String anio;
  final int fkCuatrimestre;
  final Carrera carrera;
  final String? deletedAt;

  Grupo({
    required this.pkGrupo,
    required this.nombre,
    required this.anio,
    required this.fkCuatrimestre,
    required this.carrera,
    this.deletedAt,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      pkGrupo: json['pk_grupo'],
      nombre: json['nombre'],
      anio: json['año'], 
      fkCuatrimestre: json['fk_cuatrimestre'],
      carrera: Carrera.fromJson(json['carrera']),
      deletedAt: json['deleted_at'],
    );
  }
}

class Carrera {
  final String nombre;
  final String abreviatura;

  Carrera({
    required this.nombre,
    required this.abreviatura,
  });

  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      nombre: json['nombre'],
      abreviatura: json['abreviatura'],
    );
  }
}

class Materia {
  final String nombre;

  Materia({
    required this.nombre,
  });

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      nombre: json['nombre'],
    );
  }
}
