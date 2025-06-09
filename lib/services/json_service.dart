import 'mongodb_service.dart';

class JsonService {
  static const String collectionName = 'convenios_cem';
  final MongoDBService _mongoService = MongoDBService();
  List<dynamic>? _cachedData;

  Future<List<dynamic>> loadJsonData() async {
    try {
      print('Intentando cargar datos desde MongoDB...');
      final data = await _mongoService.getCollection(collectionName);
      _cachedData = data;
      print('Datos cargados exitosamente: ${_cachedData!.length} registros');
      return _cachedData!;
    } catch (e) {
      print('Error cargando datos: $e');
      return [];
    }
  }

  Future<void> saveJsonData(List<dynamic> data) async {
    try {
      // Primero eliminamos todos los documentos existentes
      await _mongoService.deleteDocument(collectionName, {});
      
      // Luego insertamos los nuevos documentos
      for (var item in data) {
        await _mongoService.insertDocument(collectionName, item as Map<String, dynamic>);
      }
      
      _cachedData = data;
      print('Datos actualizados en MongoDB: ${data.length} registros');
    } catch (e) {
      print('Error guardando datos: $e');
      throw Exception('No se pudo actualizar los datos: $e');
    }
  }
}
