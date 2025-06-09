import 'package:flutter/material.dart';
import '../services/json_service.dart';

class ConveniosCemScreen extends StatefulWidget {
  const ConveniosCemScreen({Key? key}) : super(key: key);

  @override
  _ConveniosCemScreenState createState() => _ConveniosCemScreenState();
}

class _ConveniosCemScreenState extends State<ConveniosCemScreen> {
  final JsonService _jsonService = JsonService();
  List<dynamic> allData = [];
  String? selectedRegion;
  String? selectedEstado;
  bool isFilterExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJsonData();
    });
  }

  Future<void> _loadJsonData() async {
    try {
      print('Iniciando carga de datos...');
      final data = await _jsonService.loadJsonData();
      setState(() {
        allData = data;
      });
      print('Datos cargados en pantalla: ${allData.length} registros');
    } catch (e) {
      print('Error al cargar datos en pantalla: $e');
    }
  }

  List<dynamic> _getFilteredData() {
    return allData.where((item) {
      bool matchesRegion = selectedRegion == null || item['REGION']?.toString() == selectedRegion;
      bool matchesEstado = selectedEstado == null || item['ESTADO']?.toString() == selectedEstado;
      return matchesRegion && matchesEstado;
    }).toList();
  }

  Future<void> _saveJsonData() async {
    try {
      await _jsonService.saveJsonData(allData);
      // Recargar los datos después de guardar
      await _loadJsonData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados correctamente')),
      );
    } catch (e) {
      print('Error al guardar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los datos: $e')),
      );
    }
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
                  'Editar Convenio CEM', 
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )
                ),
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
                  initialValue: item['CREACION']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Creación',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['CREACION'] = value,
                ),
                TextFormField(
                  initialValue: item['ESTADO'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['ESTADO'] = value,
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
                  initialValue: item['SITUACION DE GESTION/NRO DE OFICIO'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Situación de Gestión/Nro de Oficio',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['SITUACION DE GESTION/NRO DE OFICIO'] = value,
                ),
                TextFormField(
                  initialValue: item['AÑO']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Año',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['AÑO'] = int.tryParse(value),
                ),
                TextFormField(
                  initialValue: item['FECHA DE SUSCRIPCION'] ?? '',
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
                  onChanged: (value) => item['FECHA DE SUSCRIPCION'] = value,
                ),
                TextFormField(
                  initialValue: item['FECHA DE VENCIMIENTO'] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Fecha de Vencimiento',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['FECHA DE VENCIMIENTO'] = value,
                ),
                TextFormField(
                  initialValue: item['LOCAL '] ?? '',
                  decoration: InputDecoration(
                    labelText: 'Local',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) => item['LOCAL '] = value,
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
                    print('Saving item: ${allData[index]}');
                    await _saveJsonData();
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
        title: const Text('Convenios CEM'),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Región: ${item['REGION'] ?? 'N/A'}',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        Text('Provincia: ${item['PROVINCIA'] ?? 'N/A'}'),
                                        Text('Distrito: ${item['DISTRITO'] ?? 'N/A'}'),
                                        Text('CEM: ${item['CEM'] ?? 'N/A'}'),
                                        Text('Contraparte: ${item['CONTRAPARTE'] ?? 'N/A'}'),
                                        Text('Creación: ${item['CREACION'] ?? 'N/A'}'),
                                        Text('Estado: ${item['ESTADO'] ?? 'N/A'}'),
                                        Text('Gestión Descent: ${item['GESTION DESCENT'] ?? 'N/A'}'),
                                        Text('Situación de Gestión/Nro de Oficio: ${item['SITUACION DE GESTION/NRO DE OFICIO'] ?? 'N/A'}'),
                                        Text('Año: ${item['AÑO'] ?? 'N/A'}'),
                                        Text('Fecha de Suscripción: ${item['FECHA DE SUSCRIPCION'] ?? 'N/A'}'),
                                        Text('Fecha de Vencimiento: ${item['FECHA DE VENCIMIENTO'] ?? 'N/A'}'),
                                        Text('Local: ${item['LOCAL '] ?? 'N/A'}'),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () => _showEditDialog(index),
                                  ),
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
            ),
    );
  }
}