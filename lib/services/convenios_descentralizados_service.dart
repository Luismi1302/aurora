import 'dart:convert';
import 'package:flutter/services.dart';

class ConveniosDescentralizadosService {
  static const String assetPath = 'assets/Convenios.Convenios_Descentralizados.json';
  List<dynamic>? _cachedData;

  Future<List<dynamic>> loadJsonData() async {
    try {
      print('Intentando cargar datos...');
      final String jsonString = await rootBundle.loadString(assetPath);
      _cachedData = json.decode(jsonString);
      print('Datos cargados exitosamente: ${_cachedData!.length} registros');
      return _cachedData!;
    } catch (e) {
      print('Error cargando datos: $e');
      return [];
    }
  }

  Future<void> saveJsonData(List<dynamic> data) async {
    try {
      _cachedData = data;
      print('Datos actualizados en memoria: ${data.length} registros');
    } catch (e) {
      print('Error guardando datos: $e');
      throw Exception('No se pudo actualizar los datos: $e');
    }
  }
}
