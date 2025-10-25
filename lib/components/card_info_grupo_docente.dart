import 'package:flutter/material.dart';

class CardInfoGrupoDocente extends StatelessWidget {
  final String grupo;
  final String cuatri;
  final String anio;
  final String carrera;
  final String? materia;
  final VoidCallback? onTap; 

  const CardInfoGrupoDocente({
    super.key,
    required this.grupo,
    required this.cuatri,
    required this.anio,
    required this.carrera,
    this.materia,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}
