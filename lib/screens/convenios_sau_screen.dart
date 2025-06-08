import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../services/convenios_sau_service.dart';
import '../services/pdf_service.dart';

class ConveniosSauScreen extends StatefulWidget {
  const ConveniosSauScreen({Key? key}) : super(key: key);

  @override
  _ConveniosSauScreenState createState() => _ConveniosSauScreenState();
}

class _ConveniosSauScreenState extends State<ConveniosSauScreen> {
  final _service = ConveniosSauService();
  final _pdfService = PdfService();
  List<dynamic> allData = [];
  String? selectedRegion;
  String? selectedEstado;
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

  Future<void> _downloadPdf() async {
    final filteredData = _getFilteredData();

    final List<Map<String, dynamic>> dataForPdf = filteredData.map((item) {
      return {
        'REGIÓN': item['REGIÓN'] ?? '',
        'PROVINCIA': item['PROVINCIA '] ?? '',
        'DISTRITO': item['DISTRITO'] ?? '',
        'SAU': item['SAU'] ?? '',
        'CONTRAPARTE': item['CONTRAPARTE'] ?? '',
        'ESTADO': item['ESTADO SITUACIONAL'] ?? '',
      };
    }).toList();

    await _pdfService.generateAndOpenPdf(
      title: 'Convenios SAU${selectedRegion != null ? ' - $selectedRegion' : ''}${selectedEstado != null ? ' - $selectedEstado' : ''}',
      data: dataForPdf,
      columns: ['REGIÓN', 'PROVINCIA', 'DISTRITO', 'SAU', 'CONTRAPARTE', 'ESTADO'],
    );
  }

  List<dynamic> _getFilteredData() {
    return allData.where((item) {
      bool matchesRegion = selectedRegion == null || item['REGION']?.toString() == selectedRegion;
      bool matchesEstado = selectedEstado == null || item['ESTADO']?.toString() == selectedEstado;
      return matchesRegion && matchesEstado;
    }).toList();
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
                  'Editar SAU', 
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  )
                ),
                TextFormField(
                  initialValue: item['SAU']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'SAU',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['SAU'] = value,
                ),
                TextFormField(
                  initialValue: item['Nº']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'N°',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['Nº'] = value,
                ),
                TextFormField(
                  initialValue: item['REGIÓN'] ?? '',
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
                  onChanged: (value) => item['REGIÓN'] = value,
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
                  initialValue: item['ESTADO SITUACIONAL'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Estado Situacional',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['ESTADO SITUACIONAL'] = value,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Datos guardados correctamente')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(String estado) {
    final isVigente = estado.toUpperCase().contains('VIGENTE');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isVigente ? Colors.red[100] : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isVigente ? Theme.of(context).primaryColor : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: isVigente ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    final regiones = allData.map((item) => item['REGION']?.toString() ?? '').toSet().toList()..sort();
    final estados = allData.map((item) => item['ESTADO']?.toString() ?? '').toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convenios SAU'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _downloadPdf,
            tooltip: 'Descargar PDF',
          ),
        ],
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
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      final situacionGestion = item['SITUACIÓN DE GESTIÓN/NRO'] as Map<String, dynamic>?;

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
                                    'SAU ${item['SAU'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildStatusIndicator(item['ESTADO SITUACIONAL']?.toString() ?? 'NO ESPECIFICADO'),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                        onPressed: () => _showEditDialog(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('N°', item['Nº']?.toString()),
                              _buildInfoRow('Región', item['REGION']),
                              _buildInfoRow('Provincia', item['PROVINCIA']),
                              _buildInfoRow('Distrito', item['DISTRITO']),
                              _buildInfoRow('Contraparte', item['CONTRAPARTE']),
                              _buildInfoRow('Fecha de suscripción del primer convenio', item['FECHA DE  SUSCRIPCIÓN DEL PRIMER CONVENIO                   (CREACIÓN SAU)']),
                              _buildInfoRow('Prórroga', item['PRÓRROGA']),
                              _buildInfoRow('Estado Situacional', item['ESTADO SITUACIONAL']),
                              _buildInfoRow('Tipo de inmueble', item['TIPO DE INMUEBLE']),
                              _buildInfoRow('Fecha de renovación', item['FECHA DE SUCRIPCIÓN DE CONVENIOS PARA SOSTENIBILIDAD DE SAU                                                 (RENOVACIÓN SAU)']),
                              _buildInfoRow('Vencimiento del convenio', item['VENCIMIENTO DEL CONVENIO']),
                              _buildInfoRow('Vencimiento con prórroga', item['VENCIMIENTO CON PRÓRROGA AUTOMÁTICA']),
                              if (situacionGestion != null)
                                _buildInfoRow('Situación de gestión', situacionGestion[' DE OFICIO']?.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
              value,
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
