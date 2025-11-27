import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:vital_chef/models/recipe.dart';

class SpoonacularApi {
  static const String _baseUrl = 'api.spoonacular.com';

  static String get _apiKey {
    final key = dotenv.env['SPOONACULAR_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('Key no está definida en el archivo .env');
    }
    return key;
  }

  /// Busca recetas por texto
  static Future<List<Recipe>> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', <String, String>{
      'apiKey': _apiKey,
      'query': query,
      'number':
          '2', // cuántas recetas queremos (mucha cantidad gasta demasiado puntos diarios de la API)
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error en la API (${response.statusCode}): ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> results = data['results'] as List<dynamic>;

    return results
        .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
