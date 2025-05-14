import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
const String baseUrl = "http://localhost:3000";

//Funció per a enviar les dades a backend per a validar-les i procedir amb el registre o mostrar errors
Future<bool> validateRegister(String name, String mail, String nick, String birth, String pass) async {

  final Uri uri = Uri.parse("$baseUrl/user/create");

  final Map<String, dynamic> body = {
    'name': name,
    'mail': mail,
    'nick': nick,
    'birth': birth,
    'pass': pass
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Registro exitoso.");
      return true;
    } else {
      print("❌ Error en el registro. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al registrar: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per a enviar les dades a backend per a validar-les i procedir amb l'inici de sessió o mostrar errors
Future<Map<String, dynamic>?> validateLogin(String mail, String pass) async {
  final Uri uri = Uri.parse("$baseUrl/user/login");

  final Map<String, dynamic> body = {
    'mail': mail,
    'pass': pass
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
      final data = jsonResponse['data'];
      print("✅ Usuario logueado: $data");
      return data;
    } else {
      print("❌ Error en el registro. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return null;
    }
  } catch (e) {
    print("🚫 Excepción al registrar: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per a modificar les dades a backend de l'usuari concret
Future<bool> modifyUserInfo(String name, String mail, String nick, String birth, String pass, String pathImage) async {

  final Uri uri = Uri.parse("$baseUrl/user/modify");

  final Map<String, dynamic> body = {
    'name': name,
    'mail': mail,
    'nick': nick,
    'pass': pass,
    'pathImage': pathImage,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Modificación exitosa.");
      return true;
    } else {
      print("❌ Error en la modificación. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al modificar: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per agafar les últimes obres afegides a la cartellera de l'apliació (les primeres 12 que surtin)
Future<List> getFilmDetails(String mediaId) async {
  final Uri uri = Uri.parse("$baseUrl/media/get-media/details?id=$mediaId");

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      final decodedBody = convert.jsonDecode(response.body);
      return List.from(decodedBody['data']);

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per agafar les últimes obres afegides a la cartellera de l'apliació (les primeres 12 que surtin)
Future<List<Map<String, dynamic>>> getLatestFilms() async {
  final Uri uri = Uri.parse("$baseUrl/media/get-media/all?p=1");

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      final decodedBody = convert.jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decodedBody['data']);

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció exlusiva per fer cerques de sèries o pel·lícules segons paraules, gèneres, el director, un actor/actriu o
//una duració indicada per l'usuari amb els filtres de cerca
Future<List<Map<String, dynamic>>> getFilmsBySearch(String search, String genre, String director,
    String actor, int duration) async {

  final Uri uri = Uri.parse("$baseUrl/media/get-media/all?p=1" + (search.isEmpty ? "" : "&search=$search")
      + (genre.isEmpty ? "" : "&genres=$genre") + (director.isEmpty ? "" : "&director=$director")
      + (actor.isEmpty ? "" : "&cast=$actor") + (duration == 0 ? "" : "&duration=$duration"));

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      final decodedBody = convert.jsonDecode(response.body);
      final data = decodedBody['data'];

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet agafar totes les pel·lícules o sèries d'un usuari, depenent de si la secció seleccionada
//és la de pel·lícules o la de sèries
Future<List<Map<String, dynamic>>> getLibraryFilms(String userMail, bool film) async {
  final Uri uri = Uri.parse("$baseUrl/library/get-media");
  String type = film ? "movie" : "show";

  final Map<String, dynamic> body = {
    'user_mail': userMail,
    'type': type,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa enseñar libreria.");
      final decodedBody = convert.jsonDecode(response.body);
      final data = decodedBody['data'];

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per crear una relació a la biblioteca entre un usuari i pel·lícula/sèrie de la id passada
Future<bool> addToLibrary(String userMail, String mediaId, String mediaInfoId, String urlFoto, String title, String type) async {
  final Uri uri = Uri.parse("$baseUrl/library/add-media");

  final Map<String, dynamic> body = {
    'user_mail': userMail,
    'media_id': mediaId,
    'info_id': mediaInfoId,
    'media_name': title,
    'media_png': urlFoto,
    'media_type': type,
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      return true;

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per eliminar una relació a la biblioteca entre un usuari i pel·lícula/sèrie de la id passada
Future<bool> deleteFromLibrary(String userMail, String mediaId, String mediaInfoId) async {
  final Uri uri = Uri.parse("$baseUrl/library/delete-media");

  final Map<String, dynamic> body = {
    'user_mail': userMail,
    'media_id': mediaId,
    'info_id': mediaInfoId,
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Request exitosa, pelicula eliminada de la biblioteca.");
      return true;

    } else {
      print("❌ Error en la request, pelicula no eliminada de la biblioteca. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request de eliminar pelicula de la biblioteca: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per afegir o modificar el comentari, la valoració o el moment d'una pel·lícula/sèrie concreta dins
//la biblioteca d'un usuari
Future<bool> modifyFromLibrary(String userMail, String mediaId, String mediaInfoId, String comment, String status,
    double rating) async {
  final Uri uri = Uri.parse("$baseUrl/library/modify-media");

  final Map<String, dynamic> body = {
    'user_mail': userMail,
    'media_id': mediaId,
    'info_id': mediaInfoId,
    'status': status,
    'rating': rating,
    'comment': comment,
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      return true;

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per aconseguir els usuaris a través de la paraula cercada
Future<List<Map<String, dynamic>>> getRatingsByFilm(String userMail, String mediaId, String infoId) async {
  final Uri uri = Uri.parse("$baseUrl/library/get-comments");

  final Map<String, dynamic> body = {
    'user_mail': userMail,
    'media_id': mediaId,
    'info_id': infoId,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa enseñar comentarios.");
      final decodedBody = convert.jsonDecode(response.body);
      final data = decodedBody['data'];

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet agafar les pel·lícules o sèries recomanades de manera intel·ligent segons els
// gustos de l'usuari actual
Future<Map<String, dynamic>> getRecomendationFilms(String userMail, List<String>? selectedGenres) async {
  final Uri uri = Uri.parse("$baseUrl/library/recommend");

  final Map<String, dynamic> body = {
    'user_mail': userMail,
    'genre_filter': selectedGenres
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      final decodedBody = convert.jsonDecode(response.body);
      return {
        'recommendations': List<Map<String, dynamic>>.from(decodedBody['recommendations']),
        'top_genres': List<String>.from(decodedBody['top_genres']),
      };

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return {};
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet eliminar una pel·lícula o sèrie de la cartellera (BD) a partir del seu títol
Future<bool> deleteFilm(String title, String media_id) async {
  final Uri uri = Uri.parse("$baseUrl/media/delete-media");

  final Map<String, dynamic> body = {
    'name': title,
    'media_id': media_id
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'KgtblvdX5JWXMG6UQvB96owx1gm3fX73lYxbWctYDFTPRAEaNXHoocTc61blvFPvivV2T1CjpFnLY9OAdPwIpRXBLSvjWjW9'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Pelicula borrada correctamente.");
      return true;

    } else {
      print("❌ Error en la eliminación de la pelicula. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la eliminación: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet agafar 10 preguntes corresponents al questionari seleccionat anteriorment
// Simulació de dades que es poden obtenir des del backend
Future<List<Map<String, dynamic>>> getQuestions(String infoId, bool admin) async {
  final Uri uri = Uri.parse("$baseUrl/questions/get");

  final Map<String, dynamic> body = {
    'info_id': infoId,
    'admin': admin,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
      final data = jsonResponse['data'];
      print("✅ Preguntas conseguidas de la BD: $data");

      // Formatejar la request per mostrar correctament el questionari
      List<Map<String, dynamic>> formattedQuestions = [];
      var item;

      for (item in data) {
        final questionText = item['question'];
        final answers = item['answers'];
        final correctIndex = item['valid'];
        final correctAnswer = answers[correctIndex];

        formattedQuestions.add({
          'id': item['id'],
          'info_id': item['info_id'],
          'question': questionText,
          'possibleAnswers': answers,
          'correctAnswer': correctAnswer,
        });
      }
      return formattedQuestions;

    } else {
      print("❌ Error al coger las preguntas. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al registrar: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet editar un qüestionari associat a una pel·lícula o sèrie de la base de dades
Future<bool> editQuestionnaire(String mediaId, String mail, String nick, String password, List<Map<String, dynamic>> updatedQuestions) async {
  var question;
  for(question in updatedQuestions){
    final Uri uri = Uri.parse("$baseUrl/questions/modify");

    final Map<String, dynamic> body = {
      'mail': mail,
      'nick': nick,
      'pass': password,
      'question_id': question['id'],
      'info_id': mediaId,
      'question': question['question'],
      'answers': question['possibleAnswers'],
      'valid': true,
      'checked': question['checked'],
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
        },
        body: convert.jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("✅ Modificación de la preguntas exitosa.");
      } else {
        print("❌ Error en la modificación de las preguntas exitosa. Código: ${response.statusCode}");
        print("Respuesta: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚫 Excepción al modificar de las preguntas exitosa: $e");
      throw Exception("No se pudo conectar al servidor.");
    }
  }
  return true;
}

//TODO: Funció per afegir un personatge com a xat
//Funció que permet afegir un personatge escollit per establir un xat amb ell/a
Future<bool> addCharacterToChat(String name) async {
  return true;
}

//Funció per aconseguir els personatges de la pel·lícula o sèrie cercada
Future<List<Map<String, dynamic>>> getCharactersBySearch(String search) async {
  final Uri uri = Uri.parse("$baseUrl/character/get-characters");

  final Map<String, dynamic> body = {
    'movie_name': search,
  };

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa mostrar personatges.");
      final decodedBody = convert.jsonDecode(response.body);
      print(decodedBody);
      final data = decodedBody['characters'];
      print(data);

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }

    } else {
      print("❌ Error en la request de mostrar personatges. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request de mostrar personatges: $e");
    throw Exception("No se pudo conectar al servidor.");
  }

}

//Funció que permet afegir un personatge a la base de dades de personatges disponibles per establir un xat amb ell/a
Future<bool> addCharacter(String name, String imagePath, String description, String movieName) async {
  final Uri uri = Uri.parse("$baseUrl/character/add-character"); //Modificar Uri

  final Map<String, dynamic> body = {
    'name': name,
    'movie_name': movieName,
    'context': description,
    'png': imagePath
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Personaje añadido correctamente.");
      return true;

    } else {
      print("❌ Error en la inserción del personaje. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la inserción del personaje: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

Future<bool> modifyCharacter(String name, String imagePath, String description, String movieName) async {
  final Uri uri = Uri.parse("$baseUrl/character/modify-character"); //Modificar Uri

  final Map<String, dynamic> body = {
    'name': name,
    'movie_name': movieName,
    'context': description,
    'png': imagePath
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Personaje modificado correctamente.");
      return true;

    } else {
      print("❌ Error en la modificación de la información del personaje. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la modificación: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet modificar la informació del personatge especificat a la base de dades de personatges disponibles
Future<bool> deleteCharacter(String name, String mediaId) async {
  final Uri uri = Uri.parse("$baseUrl/character/delete-character"); //Modificar Uri

  final Map<String, dynamic> body = {
    'name': name,
    'media_id': mediaId,
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Personaje eliminado correctamente.");
      return true;

    } else {
      print("❌ Error en la eliminación del personaje. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar la eliminación: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per aconseguir els personatges de la pel·lícula o sèrie cercada
Future<List<Map<String, dynamic>>> getChatsByUserMail(String userMail) async {
  // TODO: Implementar crida real a la base de dades
  return [
    {
      'name': "Sherlock Holmes",
      'lastMessage': "Lo descubrí porque...",
      'imagePath': "https://th.bing.com/th/id/OIP.9fKQD-5qa_01wxCsOzHGsgAAAA?w=288&h=288&rs=1&pid=ImgDetMain",
    },
    {
      'name': "Eleven",
      'lastMessage': "Estaba muy asustada.",
      'imagePath': "https://images.hdqwalls.com/download/stranger-things-eleven-art-nw-1280x2120.jpg",
    },
  ];
}

//TODO: Funció per eliminar un xat actiu
//Funció que permet eliminar un xat associat a un usuari amb un personatge
Future<bool> deleteChat(String name) async {
  return true;
}

//Funció per aconseguir els missatges associats al xat amb el personatge
Future<List<Map<String, dynamic>>> getMessagesByChat(String userMail) async {
  // TODO: Implementar crida real a la base de dades
  return [
    {
      "author": "self",
      "message": "Com vas descobrir l’últim assassí?"},
    {
      "autor": "character",
      "message": "El vaig descobrir perquè portava un llibre estrany."
    },
    {
      "autor": "character",
      "message": "Li vaig treure, i era sobre verins."},
    {
      "autor": "character",
      "message": "Hi havia sang a la part del verí que va matar a la víctima."
    },
  ];
}

//TODO: Funció per enviar missatges a la BD
//Funció que permet editar un qüestionari associat a una pel·lícula o sèrie de la base de dades
Future<bool> sendMessage(String title) async {
  return true;
}

//Funció per aconseguir els usuaris que segueix l'usuari que fa la request
Future<List<Map<String, dynamic>>> getUsersByUserMail(String userMail) async {
  final Uri uri = Uri.parse("$baseUrl/user/get-users/follows?user_mail=$userMail");

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      final decodedBody = convert.jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decodedBody['data']);

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet seguir a un usuari dins l'aplicació
Future<bool> followUser({required String? srcMail, required String dstMail}) async {
  final Uri uri = Uri.parse("$baseUrl/user/follow"); //Modificar Uri

  final Map<String, dynamic> body = {
    'srcMail': srcMail,
    'dstMail': dstMail,
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );

    if (response.statusCode == 200) {
      print("✅ Usuario seguido correctamente.");
      return true;

    } else {
      print("❌ Error al intentar seguir al usuario. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar el seguimiento: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció que permet deixar de seguir a un usuari dins l'aplicació
Future<bool> unfollowUser({required String? srcMail, required String dstMail}) async {
  final Uri uri = Uri.parse("$baseUrl/user/unfollow");

  final Map<String, dynamic> body = {
    'srcMail': srcMail,
    'dstMail': dstMail,
  };

  try {
    final response = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );
    if (response.statusCode == 200) {
      print("✅ Usuario seguido correctamente.");
      return true;

    } else {
      print("❌ Error al intentar seguir al usuario. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚫 Excepción al realizar el seguimiento: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}

//Funció per aconseguir els usuaris a través de la paraula cercada
Future<List<Map<String, dynamic>>> getUsersBySearch(String search, String mail) async {
  final Uri uri = Uri.parse("$baseUrl/user/get-users/search?user_mail=$mail&${search.isEmpty ? "" : "&search=$search"}");

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
      },
    );

    if (response.statusCode == 200) {
      print("✅ Request exitosa.");
      final decodedBody = convert.jsonDecode(response.body);
      print(decodedBody);
      return List<Map<String, dynamic>>.from(decodedBody['data']);

    } else {
      print("❌ Error en la request. Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");
      return [];
    }
  } catch (e) {
    print("🚫 Excepción al realizar la request: $e");
    throw Exception("No se pudo conectar al servidor.");
  }
}