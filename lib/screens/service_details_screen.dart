import 'package:flutter/material.dart';
import '../../services/mongodb_service.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceName;
  final String jsonFile;
  
  const ServiceDetailsScreen({
    super.key, 
    required this.serviceName,
    required this.jsonFile,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  List<dynamic> _records = [];
  bool _isLoading = true;
  String? selectedRegion;
  String? selectedEstado;
  bool isFilterExpanded = false;

  // Asociación de nombres de servicio con colecciones de MongoDB
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
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() { _isLoading = true; });
    try {
      final mongo = MongoDBService();
      final collectionName = colecciones[widget.serviceName] ?? widget.serviceName;
      final docs = await mongo.getCollection(collectionName);
      setState(() {
        _records = docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading MongoDB data: $e');
    }
  }

  List<dynamic> _getFilteredData() {
    return _records.where((item) {
      bool matchesRegion = selectedRegion == null || item['REGION']?.toString() == selectedRegion || item['region']?.toString() == selectedRegion;
      bool matchesEstado = selectedEstado == null || item['ESTADO']?.toString() == selectedEstado || item['estado']?.toString() == selectedEstado;
      return matchesRegion && matchesEstado;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    final regiones = _records.map((item) => item['REGION']?.toString() ?? item['region']?.toString() ?? '').toSet().toList()..sort();
    final estados = _records.map((item) => item['ESTADO']?.toString() ?? item['estado']?.toString() ?? '').toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text('Convenios ${widget.serviceName}'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(child: Text('No hay convenios disponibles'))
              : Column(
                  children: [
                    // Panel de filtros
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isFilterExpanded ? 170 : 50,
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isFilterExpanded = !isFilterExpanded;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.filter_list),
                                    const SizedBox(width: 8),
                                    const Text('Filtros'),
                                    const Spacer(),
                                    Text(
                                      '${filteredData.length} de ${_records.length} resultados'
                                    ),
                                    Icon(isFilterExpanded ? Icons.expand_less : Icons.expand_more),
                                  ],
                                ),
                                if (isFilterExpanded) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedRegion,
                                      isExpanded: true,
                                      hint: const Text('Seleccionar Región'),
                                      underline: const SizedBox(),
                                      items: [
                                        const DropdownMenuItem<String>(
                                          value: null,
                                          child: Text('Todas las regiones'),
                                        ),
                                        ...regiones.map((region) => DropdownMenuItem<String>(
                                          value: region,
                                          child: Text(region),
                                        )),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRegion = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedEstado,
                                      isExpanded: true,
                                      hint: const Text('Seleccionar Estado'),
                                      underline: const SizedBox(),
                                      items: [
                                        const DropdownMenuItem<String>(
                                          value: null,
                                          child: Text('Todos los estados'),
                                        ),
                                        ...estados.map((estado) => DropdownMenuItem<String>(
                                          value: estado,
                                          child: Text(estado),
                                        )),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedEstado = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Lista de convenios
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final record = filteredData[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ExpansionTile(
                              title: Text(record['REGION'] ?? record['region'] ?? 'Sin región'),
                              subtitle: Text(record['DISTRITO'] ?? record['distrito'] ?? 'Sin distrito'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailItem('Estado', record['ESTADO'] ?? record['estado']),
                                      _buildDetailItem('Fecha', record['fecha']),
                                      if (record['observaciones'] != null)
                                        _buildDetailItem('Observaciones', record['observaciones']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
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
              value?.toString() ?? '',
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
