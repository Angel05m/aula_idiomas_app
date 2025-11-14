class Usuario {
  final int id;
  final String nombres;
  final String apPaterno;
  final String apMaterno;
  final String matricula;
  final String email;
  final int fkTipoUsuario;

  Usuario({
    required this.id,
    required this.nombres,
    required this.apPaterno,
    required this.apMaterno,
    required this.matricula,
    required this.email,
    required this.fkTipoUsuario,
  });

  String get nombreCompleto => "$nombres $apPaterno $apMaterno".trim();

  String get tipoUsuarioTexto {
    switch (fkTipoUsuario) {
      case 1:
        return 'Alumno';
      case 2:
        return 'Docente';
      case 3:
        return 'Coordinador';
      default:
        return 'Desconocido';
    }
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json["pk_usuario"] ?? json["id"] ?? 0) is int
          ? (json["pk_usuario"] ?? json["id"] ?? 0)
          : int.parse((json["pk_usuario"] ?? json["id"] ?? '0').toString()),
      nombres: json["nombres"] ?? '',
      apPaterno: json["ap_paterno"] ?? '',
      apMaterno: json["ap_materno"] ?? '',
      matricula: json["matricula"] ?? '',
      email: json["email"] ?? '',
      fkTipoUsuario: (json["fk_tipo_usuario"] ?? json["fkTipoUsuario"] ?? 0) is int
          ? (json["fk_tipo_usuario"] ?? json["fkTipoUsuario"] ?? 0)
          : int.parse((json["fk_tipo_usuario"] ?? json["fkTipoUsuario"] ?? '0').toString()),
    );
  }
}
