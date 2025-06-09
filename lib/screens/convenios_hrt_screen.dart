import 'package:flutter/material.dart';
import '../services/convenios_hrt_service.dart';
import '../services/pdf_service.dart';

class ConveniosHrtScreen extends StatefulWidget {
  const ConveniosHrtScreen({super.key});

  @override
  State<ConveniosHrtScreen> createState() => _ConveniosHrtScreenState();
}

class _ConveniosHrtScreenState extends State<ConveniosHrtScreen> {
  final _service = ConveniosHrtService();
  final _pdfService = PdfService();
  String? selectedRegion;
  bool isFilterExpanded = false;
  List<dynamic> allData = [];

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
    final filteredData = selectedRegion != null
        ? allData.where((item) => item['REGIÓN']?.toString() == selectedRegion).toList()
        : allData;

    final List<Map<String, dynamic>> dataForPdf = filteredData.map((item) {
      return {
        'REGIÓN': item['REGIÓN'] ?? '',
        'PROVINCIA': item['PROVINCIA '] ?? '',
        'DISTRITO': item['DISTRITO'] ?? '',
        'HRT': item['HRT'] ?? '',
        'CONTRAPARTE': item['CONTRAPARTE'] ?? '',
        'ESTADO': item['ESTADO SITUACIONAL'] ?? '',
      };
    }).toList();

    await _pdfService.generateAndOpenPdf(
      title: 'Convenios HRT${selectedRegion != null ? ' - $selectedRegion' : ''}',
      data: dataForPdf,
      columns: ['REGIÓN', 'PROVINCIA', 'DISTRITO', 'HRT', 'CONTRAPARTE', 'ESTADO'],
    );
  }

  void _showEditDialog(int index) {
    Map<String, dynamic> item = Map<String, dynamic>.from(allData[index]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Editar HRT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildEditField(item, 'HRT', 'HRT'),
                _buildEditField(item, 'REGIÓN', 'Región'),
                _buildEditField(item, 'PROVINCIA ', 'Provincia'),
                _buildEditField(item, 'DISTRITO', 'Distrito'),
                _buildEditField(item, 'CONTRAPARTE', 'Contraparte'),
                _buildEditField(item, 'ESTADO SITUACIONAL', 'Estado Situacional'),
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

  Widget _buildEditField(Map<String, dynamic> item, String key, String label) {
    return TextFormField(
      initialValue: item[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      onChanged: (value) => item[key] = value,
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
    // Obtener lista única de regiones
    final regiones = allData.map((item) => item['REGIÓN']?.toString() ?? '').toSet().toList()..sort();
    
    // Filtrar datos por región seleccionada
    final filteredData = selectedRegion == null
        ? allData
        : allData.where((item) => item['REGIÓN']?.toString() == selectedRegion).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convenios HRT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _downloadPdf,
            tooltip: 'Descargar PDF',
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: allData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Panel de filtros
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isFilterExpanded ? 120 : 50,
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
                                  selectedRegion != null 
                                    ? '${filteredData.length} de ${allData.length} resultados' 
                                    : '${allData.length} resultados totales'
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
                                      'HRT ${item['HRT']?.toString() ?? ''}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildStatusIndicator(item['ESTADO SITUACIONAL']?.toString() ?? 'NO ESPECIFICADO'),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                        onPressed: () => _showEditDialog(filteredData.indexOf(item)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('N°', item['Nº']?.toString()),
                              _buildInfoRow('Región', item['REGIÓN']),
                              _buildInfoRow('Provincia', item['PROVINCIA ']),
                              _buildInfoRow('Distrito', item['DISTRITO']),
                              _buildInfoRow('Contraparte', item['CONTRAPARTE']),
                              _buildInfoRow('Fecha de suscripción del primer convenio', item['FECHA DE  SUSCRIPCIÓN DEL PRIMER CONVENIO                   (CREACIÓN HRT)']),
                              _buildInfoRow('Prórroga', item['PRÓRROGA']),
                              _buildInfoRow('Fecha de suscripción de convenios (Renovación)', item['FECHA DE SUCRIPCIÓN DE CONVENIOS PARA SOSTENIBILIDAD DE HRT                                                                      (RENOVACIÓN HRT) ']),
                              _buildInfoRow('Vencimiento del convenio', item['VENCIMIENTO DEL CONVENIO']),
                              _buildInfoRow('Vencimiento con prórroga automática', item['VENCIMIENTO CON PRÓRROGA AUTOMÁTICA']),
                              _buildInfoRow('Estado Situacional', item['ESTADO SITUACIONAL']),
                              _buildInfoRow('Tipo de inmueble', item['TIPO DE INMUEBLE ']),
                              if (item['SITUACIÓN DE GESTIÓN/NRO'] != null)
                                _buildInfoRow('Situación de gestión', (item['SITUACIÓN DE GESTIÓN/NRO'] as Map<String, dynamic>)[' DE OFICIO']?.toString()),
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
