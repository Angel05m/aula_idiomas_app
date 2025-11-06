import 'package:aula_idiomas_app/screens/coordinacion/aignar_grupo_alumno.dart';
import 'package:flutter/material.dart';

class CardInfoGrupo extends StatelessWidget {
  final int pk_grupo;
  final String grupo;
  final String cuatri;
  final String anio;
  final String carrera;
  final String? materia;
  final VoidCallback? onTap; 
  final VoidCallback? onToggleStatus;
  final bool isDisabled;

  const CardInfoGrupo({
    required this.pk_grupo,
    super.key,
    required this.grupo,
    required this.cuatri,
    required this.anio,
    required this.carrera,
    this.materia,
    this.onTap, 
    this.onToggleStatus,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        color: isDisabled ? Colors.grey[200] : Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: Colors.teal.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.teal,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grupo,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$cuatri • $anio',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(
                      height: 16,
                      thickness: 1,
                      color: Color(0xFFE0E0E0),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.account_balance_rounded,
                            size: 18, color: Colors.teal),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Carrera: $carrera',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (materia != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded,
                              size: 18, color: Colors.teal),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Materia: $materia',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AsignarGrupoAlumno(
                              pk_grupo: pk_grupo.toString(), 
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add_circle, 
                        size: 20,
                        color: Colors.teal
                      ),
                    ),
                    TextButton(
                      onPressed: onToggleStatus, 
                      child: Icon(
                        isDisabled ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_down_outlined,
                        color: isDisabled ? Colors.green[600] : Colors.red[600],
                        size: 26,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
