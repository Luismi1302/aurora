import 'package:flutter/material.dart';
import '../services/convenios_descentralizados_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<List<dynamic>> _loadMongoData() async {
    final service = ConveniosDescentralizadosService();
    return await service.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convenios Descentralizados',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Convenios Descentralizados'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _loadMongoData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            } else {
              final List<dynamic> data = snapshot.data ?? [];

              if (data.isEmpty) {
                return const Center(child: Text('No hay datos disponibles.'));
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ListTile(
                    title: Text(item['CEM'] ?? 'Sin nombre'),
                    subtitle: Text(item['REGION'] ?? ''),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
