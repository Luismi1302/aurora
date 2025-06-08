import 'package:flutter/material.dart';
import '../services/semaforizacion_service.dart';

class SemaforizacionScreen extends StatefulWidget {
  const SemaforizacionScreen({Key? key}) : super(key: key);

  @override
  _SemaforizacionScreenState createState() => _SemaforizacionScreenState();
}

class _SemaforizacionScreenState extends State<SemaforizacionScreen> {
  final _service = SemaforizacionService();
  List<dynamic> allData = [];
  String? selectedRegion;
  String? selectedServicio;
  bool isFilterExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final data = await _service.loadJsonData();
      setState(() {
        allData = data;
      });
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  List<dynamic> _getFilteredData() {
    return allData.where((item) {
      bool matchesRegion = selectedRegion == null || item['REGION']?.toString() == selectedRegion;
      bool matchesServicio = selectedServicio == null || item['SERVICIO']?.toString() == selectedServicio;
      return matchesRegion && matchesServicio;
    }).toList();
  }

  Widget _buildToggleSection(Map<String, dynamic> item) {
    final toggleFields = [
      'Proporciona los bienes muebles necesarios como mobiliario del servicio',
      'Gestiona la instalación y cubre los gastos mensuales de una línea telefónica e internet para uso exclusivo del servicio',
      'Asume el pago de las retribuciones económicas de los profesionales del equipo del servicio',
      // Add other toggle fields here
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: toggleFields.map((field) {
        final bool value = item[field] ?? false;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (bool? newValue) {
                  setState(() {
                    item[field] = newValue ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(field),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    final regiones = allData.map((item) => item['REGION']?.toString() ?? '').toSet().toList()..sort();
    final servicios = allData.map((item) => item['SERVICIO']?.toString() ?? '').toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: allData.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
                                  '${filteredData.length} de ${allData.length} resultados'
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
                                  value: selectedServicio,
                                  isExpanded: true,
                                  hint: const Text('Seleccionar Servicio'),
                                  underline: const SizedBox(),
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text('Todos los servicios'),
                                    ),
                                    ...servicios.map((servicio) => DropdownMenuItem<String>(
                                      value: servicio,
                                      child: Text(servicio),
                                    )),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedServicio = value;
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
                // Lista de servicios
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: ExpansionTile(
                          title: Text(
                            item['NOMBRE DEL SERVICIO'] ?? 'N/A',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          subtitle: Text('${item['REGION']} - ${item['SERVICIO']}'),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Provincia: ${item['PROVINCIA']}'),
                                    Text('Distrito: ${item['DISTRITO']}'),
                                    Text('Contraparte: ${item['CONTRAPARTE']}'),
                                    const Divider(),
                                    _buildToggleSection(item),
                                  ],
                                ),
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
}
