import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static Future<Map<String, dynamic>?> buscarCep(String cep) async {
    final response = await http
        .get(Uri.parse('https://viacep.com.br/ws/$cep/json/'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Não foi possível consultar o CEP.');
    }

    final Map<String, dynamic> dados = jsonDecode(
      utf8.decode(response.bodyBytes),
    );
    if (dados['erro'] == true || dados['erro'] == 'true') {
      return null;
    }
    return dados;
  }
}
