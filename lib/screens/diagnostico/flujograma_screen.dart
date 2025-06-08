import 'package:flutter/material.dart';

class FlujogramaScreen extends StatelessWidget {
  final Map<String, dynamic> registro;
  const FlujogramaScreen({Key? key, required this.registro}) : super(key: key);

  List<Map<String, String>> _generarFlujograma() {
    // Puedes personalizar los pasos según el tipo o estado del registro
    return [
      {
        'paso': 'Recepción de solicitud',
        'responsable': registro['CONTRAPARTE'] ?? 'Oficina de Mesa de Partes',
      },
      {
        'paso': 'Evaluación técnica',
        'responsable': 'Equipo Técnico',
      },
      {
        'paso': 'Validación de requisitos',
        'responsable': 'Coordinador Regional',
      },
      {
        'paso': 'Firma de convenio',
        'responsable': registro['CONTRAPARTE'] ?? 'Entidad Contraparte',
      },
      {
        'paso': 'Seguimiento y monitoreo',
        'responsable': 'Supervisor de Compromisos',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pasos = _generarFlujograma();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flujograma'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pasos.length,
        separatorBuilder: (_, __) => const Icon(Icons.arrow_downward, color: Color(0xFF7D5492)),
        itemBuilder: (context, index) {
          final paso = pasos[index];
          return Card(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red[800],
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text(
                paso['paso'] ?? 'Paso ${index + 1}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Text('Responsable: ${paso['responsable'] ?? ''}'),
            ),
          );
        },
      ),
    );
  }
}
