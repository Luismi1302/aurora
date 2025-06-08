import 'package:flutter/material.dart';

class OperatividadScreen extends StatelessWidget {
  const OperatividadScreen({super.key});

  // Sample data
  final List<Map<String, String>> casos = const [
    {
      'titulo': 'Caso 1',
      'descripcion': 'Descripción del caso 1',
      'estado': 'Activo'
    },
    {
      'titulo': 'Caso 2',
      'descripcion': 'Descripción del caso 2',
      'estado': 'Pendiente'
    },
    {
      'titulo': 'Caso 3',
      'descripcion': 'Descripción del caso 3',
      'estado': 'Completado'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7D5492),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/logo.png',
                height: 40,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Operatividad'),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: casos.length,
        itemBuilder: (context, index) {
          final caso = casos[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(caso['titulo'] ?? 'Sin título'),
              subtitle: Text(caso['descripcion'] ?? 'Sin descripción'),
              trailing: Chip(
                label: Text(
                  caso['estado'] ?? 'Sin estado',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF7D5492),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Caso seleccionado: ${index + 1}')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7D5492),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función para agregar nuevo caso'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
