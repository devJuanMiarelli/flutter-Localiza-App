import 'package:http/http.dart' as http;
import 'dart:convert';

class VeiculoService {
  final String baseUrl =
      'http://localhost:8080/veiculos'; // Atualize a URL conforme necessário

  Future<List<dynamic>> fetchVehicles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar veículos: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erro ao se conectar com a API: $e');
    }
  }

  Future<void> createVeiculo(Map<String, dynamic> veiculo) async {
    // Monta o corpo da requisição
    var requestBody = {
      'modelo': veiculo['modelo'],
      'categoria': veiculo['categoria'],
      'valor': veiculo['valor'],
      'disponibilidade': veiculo['disponivel']
          .toString(), // Certifique-se de que é 'disponivel'
      'imagem': veiculo['imagem'], // Imagem em formato Base64
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao criar veículo: ${response.reasonPhrase}');
    }
  }

  Future<void> updateVeiculo(int id, Map<String, dynamic> veiculo) async {
    // Monta o corpo da requisição
    var requestBody = {
      'modelo': veiculo['modelo'],
      'categoria': veiculo['categoria'],
      'valor': veiculo['valor'],
      'disponibilidade': veiculo['disponivel']
          .toString(), // Certifique-se de que é 'disponivel'
      'imagem': veiculo['imagem'], // Atualiza a imagem se necessário
    };

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar veículo: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteVeiculo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir veículo: ${response.reasonPhrase}');
    }
  }

  Future<void> reserveVeiculo(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/$id/reserve'));
    if (response.statusCode != 204) {
      throw Exception('Falha ao reservar veículo: ${response.reasonPhrase}');
    }
  }

  Future<void> liberarVeiculo(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/$id/liberar'));
    if (response.statusCode != 204) {
      throw Exception('Falha ao liberar veículo: ${response.reasonPhrase}');
    }
  }
}
