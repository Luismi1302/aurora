import 'package:flutter/material.dart';
import '../../services/mongodb_service.dart';
import 'flujograma_screen.dart';

class MatrizCompromisosScreen extends StatefulWidget {
  const MatrizCompromisosScreen({Key? key}) : super(key: key);

  @override
  State<MatrizCompromisosScreen> createState() => _MatrizCompromisosScreenState();
}

class _MatrizCompromisosScreenState extends State<MatrizCompromisosScreen> {
  List<Map<String, dynamic>> allData = [];
  String? selectedTipo;
  bool isLoading = true;

  // Asociación de tipos con nombres de colecciones en MongoDB
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
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() { isLoading = true; });
    List<Map<String, dynamic>> temp = [];
    final mongo = MongoDBService();
    for (var entry in colecciones.entries) {
      final List<Map<String, dynamic>> docs = List<Map<String, dynamic>>.from(
        await mongo.getCollection(entry.value)
      );
      for (var item in docs) {
        temp.add({
          'tipo': entry.key,
          'region': item['REGION'] ?? item['REGIÓN'] ?? '',
          'provincia': item['PROVINCIA'] ?? item['PROVINCIA '] ?? '',
          'distrito': item['DISTRITO'] ?? '',
          'nombre': item['CEM'] ?? item['SAU'] ?? item['SAR'] ?? item['HRT'] ?? item['CAI'] ?? item['NOMBRE DEL SERVICIO'] ?? '',
          'estado': item['ESTADO'] ?? item['ESTADO SITUACIONAL'] ?? '',
          'contraparte': item['CONTRAPARTE'] ?? '',
          'raw': item,
        });
      }
    }
    setState(() {
      allData = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tipos = colecciones.keys.toList();
    final filtered = selectedTipo == null
        ? allData
        : allData.where((e) => e['tipo'] == selectedTipo).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matriz de Compromisos'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red[50]!, Colors.white],
            ),
          ),
          child: Column(
            children: [
              // Filtro por tipo
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: selectedTipo,
                  decoration: InputDecoration(
                    labelText: 'Filtrar por tipo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todos'),
                    ),
                    ...colecciones.keys.map((tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo),
                    )),
                  ],
                  onChanged: (value) => setState(() => selectedTipo = value),
                ),
              ),
              // Lista de convenios
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nombre'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  item['tipo'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.account_tree,
                              color: Theme.of(context).primaryColor,
                            ),
                            tooltip: 'Ver flujograma',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlujogramaScreen(registro: item['raw']),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Región', item['region']),
                              _buildInfoRow('Provincia', item['provincia']),
                              _buildInfoRow('Distrito', item['distrito']),
                              _buildInfoRow('Estado', item['estado']),
                              _buildInfoRow('Contraparte', item['contraparte']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
