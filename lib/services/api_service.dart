import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static final baseUrl = 'http://192.168.43.153/rest-services'; // Cambiar la URL base de tu API
  static String? authToken; // Variable para almacenar el token de autenticación
  static String userAuth = ""; // Variable para almacenar el usuario autenticado

  static Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth');
    final body = json.encode({
      "username": username,
      "password": password,
    });

    final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      ApiService.userAuth = json.decode(response.body)['data'].toString(); // Almacenar el usuario autenticado en la variable userAuth
      ApiService.authToken = token; // Almacenar el token de autenticación en la variable authToken
      return token;
    } else if (json.decode(response.body)['status'] == 'error') {
      return null;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<List<dynamic>> getMovimientos(String numeroCuenta) async {
    final url = Uri.parse('$baseUrl/cuentas/$numeroCuenta/movimientos');

    final response = await http.get(url, headers: {'content-Type': 'application/json','authorization': 'Bearer $authToken'});

    print(response.body);
    if (response.statusCode == 200) {
      final movimientos = json.decode(response.body)['rows'];
      return movimientos;
    } else {
      throw Exception('Failed to fetch movimientos');
    }
  }

  static Future<List<dynamic>> getCuentas(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/cuentas');

    final response = await http.get(url, headers: {'content-Type': 'application/json','authorization': 'Bearer $authToken'});

    if (response.statusCode == 200) {
      final cuentas = json.decode(response.body)['rows'];
      return cuentas;
    } else {
      throw Exception('Failed to fetch cuentas');
    }
  }

  static Future<void> movimiento(String origen, String monto, String destino) async {
    final url = Uri.parse('$baseUrl/movimiento');
    final body = json.encode({
      "origen": origen,
      "monto": monto,
      "destino": destino,
    });
    print(body);

    final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json', 'authorization': 'Bearer $authToken'});

    if (response.statusCode != 200) {
      throw Exception('Failed to make movimiento');
    }
  }

  static Future<double> saldo(String userId, String cuentaNumero) async {
    final url = Uri.parse('$baseUrl/users/$userId/cuentas/$cuentaNumero/saldo');
    
    final response = await http.get(url, headers: {'content-Type': 'application/json', 'authorization': 'Bearer $authToken'});
    
    if (response.statusCode == 200) {
      final saldo = json.decode(response.body)['saldo'];
      return saldo;
    } else {
      throw Exception('Failed to fetch saldo');
    }
  }
  // Implementar otros métodos para interactuar con tu API REST (ej: obtener transacciones, etc.)
}

