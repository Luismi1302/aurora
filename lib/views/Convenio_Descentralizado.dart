import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Carga el JSON desde assets
  Future<List<dynamic>> _loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/Convenios.Convenios_Descentralizados.json');
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convenios Descentralizados',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Convenios Descentralizados'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _loadJsonData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<dynamic> data = snapshot.data ?? [];

              if (data.isEmpty) {
                return Center(child: Text('El archivo JSON está vacío.'));
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];

                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CEM ${item['CEM'] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7D5492),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (item['GESTION DESCENT']?.toString() == 'transf') 
                                    ? Colors.green[100] 
                                    : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['GESTION DESCENT']?.toString() ?? '',
                                  style: TextStyle(
                                    color: (item['GESTION DESCENT']?.toString() == 'transf')
                                      ? Colors.green[900] 
                                      : Colors.orange[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Región', item['REGION']),
                          _buildInfoRow('Provincia', item['PROVINCIA']),
                          _buildInfoRow('Distrito', item['DISTRITO']),
                          const Divider(height: 20),
                          _buildInfoRow('Contraparte', item['CONTRAPARTE']),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Añadir este método helper en la clase
  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'No especificado',
              style: const TextStyle(
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
