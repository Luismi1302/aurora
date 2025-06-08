import 'package:flutter/material.dart';
import '../services/convenios_cai_service.dart';

class ConveniosCaiScreen extends StatefulWidget {
  const ConveniosCaiScreen({Key? key}) : super(key: key);

  @override
  _ConveniosCaiScreenState createState() => _ConveniosCaiScreenState();
}

class _ConveniosCaiScreenState extends State<ConveniosCaiScreen> {
  final _service = ConveniosCaiService();
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
                  'Editar CAI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )
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
                  initialValue: item['PROVINCIA '] ?? '',
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
                  onChanged: (value) => item['PROVINCIA '] = value,
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
                  initialValue: item['CAI'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'CAI',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['CAI'] = value,
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
                  initialValue: item['FECHA DE  SUSCRIPCIÓN DEL PRIMER CONVENIO                   (CREACIÓN CAI)'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Fecha de Suscripción',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['FECHA DE  SUSCRIPCIÓN DEL PRIMER CONVENIO                   (CREACIÓN CAI)'] = value,
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
    final filteredData = _getFilteredData();
    final regiones = allData.map((item) => item['REGION']?.toString() ?? '').toSet().toList()..sort();
    final estados = allData.map((item) => item['ESTADO']?.toString() ?? '').toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convenios CAI'),
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
                      return Card(
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
                                      'CAI ${item['CAI'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                    onPressed: () => _showEditDialog(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Región: ${item['REGIÓN'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              Text(
                                'Provincia: ${item['PROVINCIA '] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              Text(
                                'Distrito: ${item['DISTRITO'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              Text(
                                'Contraparte: ${item['CONTRAPARTE'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              Text(
                                'Estado: ${item['ESTADO SITUACIONAL'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              Text(
                                'Tipo de inmueble: ${item['TIPO DE INMUEBLE '] ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              if (item['SITUACIÓN DE GESTIÓN/NRO'] != null)
                                Text(
                                  'Situación: ${item['SITUACIÓN DE GESTIÓN/NRO'][' DE OFICIO'] ?? 'N/A'}',
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
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
}
