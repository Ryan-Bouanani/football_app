import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiKey = '6356f969be944f7e86bbf5edc16a7d74';

  ApiService() {
    _dio.options.headers['X-Auth-Token'] = _apiKey;
  }

  Future<void> get(String url, Function(dynamic) onSuccess, Function() onError, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      onSuccess(response.data);
    } catch (e) {
      print('Erreur lors de la requête GET: $e');
      onError();
    }
  }

  // Ajoutez d'autres méthodes HTTP (POST, PUT, DELETE, etc.) si nécessaire
}
