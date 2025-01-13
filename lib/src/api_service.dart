import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiKey = '6356f969be944f7e86bbf5edc16a7d74';
  static const String _baseUrl = 'https://api.football-data.org/v4';

  ApiService() {
    _dio.options.headers['X-Auth-Token'] = _apiKey;
    _dio.options.baseUrl = _baseUrl;
  }

  Future<void> get(
    String url,
    Function(dynamic) onSuccess,
    Function() onError, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      onSuccess(response.data);
    } catch (e) {
      print('Erreur lors de la requête GET: $e');
      onError();
    }
  }

  Future<void> fetchCompetitions(
    Function(List<String>) onSuccess,
    Function() onError,
  ) async {
    try {
      final response = await _dio.get('/competitions');
      List<String> competitionCodes = (response.data['competitions'] as List)
          .map((competition) => competition['code'] as String)
          .toList();
      onSuccess(competitionCodes);
    } catch (e) {
      print('Erreur lors de la récupération des compétitions: $e');
      onError();
    }
  }

  Future<void> fetchTeamDetails({
    required int teamId,
    required Function(Map<String, dynamic>) onSuccess,
    required Function() onError,
  }) async {
    final url = '/teams/$teamId';
    get(
      url,
      (data) => onSuccess(data as Map<String, dynamic>),
      onError,
    );
  }
}
