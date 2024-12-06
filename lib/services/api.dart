import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://api.football-data.org/v4/teams/511';
  static const String _token = '6356f969be944f7e86bbf5edc16a7d74';

  Future<Map<String, dynamic>> fetchTeamDetails() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'X-Auth-Token': _token,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load team details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
