import 'package:mongo_dart/mongo_dart.dart';
import 'mongodb_service.dart';

class ConveniosDescentralizadosService {
  static const String collectionName = 'Convenios Descentralizados';
  final MongoDBService _mongoService = MongoDBService();
  List<dynamic>? _cachedData;

  Future<List<dynamic>> loadData() async {
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
      _cachedData = data;
      print('Datos actualizados en memoria: ${data.length} registros');
    } catch (e) {
      print('Error guardando datos: $e');
      throw Exception('No se pudo actualizar los datos: $e');
    }
  }
}
