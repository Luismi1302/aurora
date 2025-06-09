import 'package:flutter/material.dart';
import '../../services/mongodb_service.dart';

class RegistroFactoresScreen extends StatefulWidget {
  const RegistroFactoresScreen({Key? key}) : super(key: key);

  @override
  State<RegistroFactoresScreen> createState() => _RegistroFactoresScreenState();
}

class _RegistroFactoresScreenState extends State<RegistroFactoresScreen> {
  List<dynamic> data = [];
  final Map<int, List<String>> factoresPorRegistro = {};
  final Map<int, TextEditingController> controllers = {};
  bool isLoading = true;

  final Map<String, String> colecciones = {
    'CEM': 'Convenios CEM',
    'Descentralizados': 'Convenios Descentralizados',
    'SAU': 'Convenio SAU',
    'SAR': 'Convenio SAR',
    'HRT': 'Convenio HRT',
    'CAI': 'Convenio CAI',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { isLoading = true; });
    final mongo = MongoDBService();
    final docs = await mongo.getCollection('Semaforizacion');
    print('Documentos traídos de MongoDB: ${docs.length}');
    if (docs.isNotEmpty) {
      print('Ejemplo de documento:');
      print(docs.first);
    }
    setState(() {
      data = docs;
      isLoading = false;
    });
  }

  void _addFactor(int index) {
    final controller = controllers[index];
    if (controller != null && controller.text.trim().isNotEmpty) {
      setState(() {
        factoresPorRegistro.putIfAbsent(index, () => []);
        factoresPorRegistro[index]!.add(controller.text.trim());
        controller.clear();
      });
    }
  }

  Color _getCardColor(Map<String, dynamic> item) {
    // Contar la cantidad de respuestas 'SI' y 'NO' en los campos tipo String
    int siCount = 0;
    int noCount = 0;
    item.forEach((key, value) {
      if (value is String) {
        if (value.trim().toUpperCase() == 'SI') siCount++;
        if (value.trim().toUpperCase() == 'NO') noCount++;
      }
    });
    // Lógica de color: verde si hay más 'SI', rojo si hay más 'NO', amarillo si igual
    if (siCount > noCount) return Colors.green[100]!;
    if (noCount > siCount) return Colors.red[100]!;
    return Colors.yellow[100]!;
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Factores'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
            ? const Center(child: Text('No hay datos disponibles en la colección Semaforizacion.'))
            : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            controllers.putIfAbsent(index, () => TextEditingController());
            final factores = factoresPorRegistro[index] ?? [];
            return Card(
              color: _getCardColor(item),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['NOMBRE DEL SERVICIO'] ?? 'Sin nombre',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Región: ${item['REGION'] ?? ''}'),
                    Text('Estado: ${item['ESTADO'] ?? ''}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Agregar factor',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _addFactor(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7D5492),
                            side: const BorderSide(color: Color(0xFF7D5492)),
                          ),
                          child: const Text('Agregar'),
                        ),
                      ],
                    ),
                    if (factores.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text('Factores registrados:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...factores.map((f) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.check, color: Colors.green, size: 20),
                            title: Text(f),
                          )),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
