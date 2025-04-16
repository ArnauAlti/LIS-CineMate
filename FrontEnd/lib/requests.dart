import 'package:http/http.dart' as http;
const String baseUrl = "http://localhost:8080";

//Funció per a enviar les dades a backend per a validar-les i procedir amb el registre o mostrar errors
Future<bool> validateRegister(String name, String mail, String nick, int birth, String pass) async {
  Uri uri = Uri.parse("$baseUrl/validate_register?$name&$mail&$nick&$birth&$pass");
  final response = await http.get(uri);

  /*
  if (response.statusCode == 200) {
  //TODO: Modificar codi de la resposta
    print("statusCode=$response.statusCode");
    print(response.body);
    Map<String, dynamic> decoded = convert.jsonDecode(response.body);
    return Tree(decoded);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    print("statusCode=$response.statusCode");
    throw Exception('failed to get answer to request $uri');
  }
  */

  return true;
}

//Funció per a enviar les dades a backend per a validar-les i procedir amb l'inici de sessió o mostrar errors
Future<bool> validateLogin(String mail, String pass) async {
  Uri uri = Uri.parse("$baseUrl/validate_register?$mail&$pass");
  final response = await http.get(uri);

  /*
  if (response.statusCode == 200) {
  //TODO: Modificar codi de la resposta
    print("statusCode=$response.statusCode");
    print(response.body);
    Map<String, dynamic> decoded = convert.jsonDecode(response.body);
    return Tree(decoded);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    print("statusCode=$response.statusCode");
    throw Exception('failed to get answer to request $uri');
  }
  */

  return true;
}