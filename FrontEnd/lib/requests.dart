import 'package:http/http.dart' as http;

//Funció per a enviar les dades a backend per a validar-les i procedir amb el registre o mostrar errors
Future<bool> validateRegister(String name, String mail, String userName, int year, String password) async {
  return true;
}

//Funció per a enviar les dades a backend per a validar-les i procedir amb l'inici de sessió o mostrar errors
Future<bool> validateLogin(String mail, String password) async {
  return true;
}