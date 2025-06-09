import 'package:flutter/material.dart';
import '../services/convenios_descentralizados_service.dart';
import '../services/pdf_service.dart';

class ConveniosDescentralizadosScreen extends StatefulWidget {
  const ConveniosDescentralizadosScreen({super.key});

  @override
  _ConveniosDescentralizadosScreenState createState() => _ConveniosDescentralizadosScreenState();
}

class _ConveniosDescentralizadosScreenState extends State<ConveniosDescentralizadosScreen> {
  final _service = ConveniosDescentralizadosService();
  final _pdfService = PdfService();
  String? selectedRegion;
  List<dynamic> allData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.loadData();
      setState(() {
        allData = data;
      });
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  Future<void> _downloadPdf() async {
    final filteredData = selectedRegion != null
        ? allData.where((item) => item['REGION']?.toString().trim() == selectedRegion).toList()
        : allData;

    final List<Map<String, dynamic>> dataForPdf = filteredData.map((item) {
      return {
        'REGION': item['REGION'] ?? '',
        'PROVINCIA': item['PROVINCIA'] ?? '',
        'DISTRITO': item['DISTRITO'] ?? '',
        'NOMBRE': item['NOMBRE'] ?? '',
        'ESTADO': item['ESTADO'] ?? '',
        'CONTRAPARTE': item['CONTRAPARTE'] ?? '',
      };
    }).toList();

    await _pdfService.generateAndOpenPdf(
      title: 'Convenios Descentralizados${selectedRegion != null ? ' - $selectedRegion' : ''}',
      data: dataForPdf,
      columns: ['REGION', 'PROVINCIA', 'DISTRITO', 'NOMBRE', 'ESTADO', 'CONTRAPARTE'],
    );
  }

  void _showEditDialog(int index) {
    Map<String, dynamic> item = Map<String, dynamic>.from(allData[index]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Editar Convenio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // Campos de texto con bordes transparentes
                TextFormField(
                  initialValue: item['REGION'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Región',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['REGION'] = value,
                ),
                TextFormField(
                  initialValue: item['PROVINCIA'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Provincia',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['PROVINCIA'] = value,
                ),
                TextFormField(
                  initialValue: item['DISTRITO'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Distrito',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['DISTRITO'] = value,
                ),
                TextFormField(
                  initialValue: item['CEM'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'CEM',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['CEM'] = value,
                ),
                TextFormField(
                  initialValue: item['CONTRAPARTE'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Contraparte',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['CONTRAPARTE'] = value,
                ),
                TextFormField(
                  initialValue: item['GESTION DESCENT'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Gestión Descent',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['GESTION DESCENT'] = value,
                ),
                TextFormField(
                  initialValue: item['OBSERVACION'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Observación',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['OBSERVACION'] = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar'),
                  onPressed: () async {
                    allData[index] = item;
                    await _service.saveJsonData(allData);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Convenios Descentralizados',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _downloadPdf,
            tooltip: 'Descargar PDF',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: FutureBuilder(
          future: _service.loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<dynamic> data = allData;

            if (data.isEmpty) {
              return const Center(child: Text('No hay datos disponibles'));
            }

            // Procesar y normalizar las regiones para el filtro
            final List<String> regionesOrdenadas = data
                .map((item) => (item['REGION']?.toString() ?? '').trim())
                .where((region) => region.isNotEmpty)
                .toSet()
                .toList()
              ..sort((a, b) => a.compareTo(b));

            // Filtrar datos por región seleccionada
            final List<dynamic> filteredData = selectedRegion != null
                ? data.where((item) {
                    var regionItem = item['REGION']?.toString() ?? '';
                    return regionItem.trim() == selectedRegion;
                  }).toList()
                : data;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.transparent), // Borde transparente
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedRegion,
                      hint: const Text('Filtrar por región'),
                      isExpanded: true,
                      underline: Container(),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todas las regiones'),
                        ),
                        ...regionesOrdenadas.map((String region) {
                          return DropdownMenuItem<String>(
                            value: region,
                            child: Text(region),
                          );
                        }),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRegion = newValue;
                        });
                      },
                    ),
                  ),
                ),
                // Mostrar contador de resultados
                if (selectedRegion != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Mostrando ${filteredData.length} resultados para $selectedRegion',
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
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
                                  Expanded(
                                    child: Text(
                                      'CEM ${item['CEM'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7D5492),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (item['GESTION DESCENT']?.toString() == 'transf')
                                              ? Colors.red[100]
                                              : Colors.red[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item['GESTION DESCENT']?.toString() ?? '',
                                          style: TextStyle(
                                            color: (item['GESTION DESCENT']?.toString() == 'transf')
                                                ? Colors.red[900]
                                                : Colors.red[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                        onPressed: () => _showEditDialog(filteredData.indexOf(item)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow('Región', item['REGION']),
                              _buildInfoRow('Provincia', item['PROVINCIA']),
                              _buildInfoRow('Distrito', item['DISTRITO']),
                              const Divider(height: 20),
                              _buildInfoRow('Contraparte', item['CONTRAPARTE']),
                              if (item['OBSERVACION'] != null && item['OBSERVACION'].toString().isNotEmpty)
                                Column(
                                  children: [
                                    const Divider(height: 20),
                                    _buildInfoRow('Observación', item['OBSERVACION']),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value, [VoidCallback? onEdit]) {
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
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
