import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class RegistroFactoresScreen extends StatefulWidget {
  const RegistroFactoresScreen({Key? key}) : super(key: key);

  @override
  State<RegistroFactoresScreen> createState() => _RegistroFactoresScreenState();
}

class _RegistroFactoresScreenState extends State<RegistroFactoresScreen> {
  List<dynamic> data = [];
  final Map<int, List<String>> factoresPorRegistro = {};
  final Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonString = await rootBundle.loadString('assets/Convenios.Semaforizacion.json');
    setState(() {
      data = json.decode(jsonString);
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
      body: Container(
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
                          child: const Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF7D5492),
                            side: const BorderSide(color: Color(0xFF7D5492)),
                          ),
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
