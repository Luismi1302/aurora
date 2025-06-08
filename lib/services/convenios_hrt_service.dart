import 'dart:convert';
import 'package:flutter/services.dart';

class ConveniosHrtService {
  static const String assetPath = 'assets/Convenios.Convenio_HRT.json';
  List<dynamic>? _cachedData;

  Future<List<dynamic>> loadJsonData() async {
    try {
      if (_cachedData != null) return _cachedData!;
      final String jsonString = await rootBundle.loadString(assetPath);
      _cachedData = json.decode(jsonString);
      return _cachedData!;
    } catch (e) {
      print('Error cargando JSON: $e');
      return [];
    }
  }

  Future<void> saveJsonData(List<dynamic> data) async {
    try {
      _cachedData = data;
      print('Datos actualizados en caché: ${data.length} registros');
    } catch (e) {
      print('Error guardando datos: $e');
      throw Exception('Error al guardar los datos: $e');
    }
  }
}
