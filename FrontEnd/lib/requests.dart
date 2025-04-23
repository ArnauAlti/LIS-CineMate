import 'package:http/http.dart' as http;
const String baseUrl = "http://localhost:3000";

//Funció per a enviar les dades a backend per a validar-les i procedir amb el registre o mostrar errors
Future<bool> validateRegister(String name, String mail, String nick, int birth, String pass) async {

  /*
  Uri uri = Uri.parse("$baseUrl/validate_register?$name&$mail&$nick&$birth&$pass");
  final response = await http.get(uri);

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

  /*
  Uri uri = Uri.parse("$baseUrl/validate_register?$mail&$pass");
  final response = await http.get(uri);

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

//Funció per agafar les últimes obres afegides a la cartellera de l'apliació (les primeres 12 que surtin)
Future<List<Map<String, dynamic>>> getLatestFilms() async {
  //TODO: Modificar per agafar películes i sèries de la biblioteca de l'usuari de la BD
  return [
    {
      'title': 'Captain America: Brave New World',
      'imagePath': 'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
      'releaseDate': 2025,
      'duration': 119,
      'platforms': 'Disney+',
      'cast': ['Anthony Mackie', 'Harrison Ford'],
      'rating': 3.5,
      'description': 'Tras reunirse con el recién elegido presidente de EE.UU. Thaddeus Ross (Harrison Ford), '
          'Sam se encuentra en medio de un incidente internacional...',
    },
    {
      'title': 'Deadpool & Wolverine',
      'imagePath': 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/7229d393-c3b8-4703-a41e-e876546d2612/dgukxa3-35713cc0-ca62-46d1-be6e-bf653f78c58e.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzcyMjlkMzkzLWMzYjgtNDcwMy1hNDFlLWU4NzY1NDZkMjYxMlwvZGd1a3hhMy0zNTcxM2NjMC1jYTYyLTQ2ZDEtYmU2ZS1iZjY1M2Y3OGM1OGUuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.6unGo3zIe5tU3wjb7_JU0IX-rMOmpFVZFJrPe7onm44',
      'releaseDate': 2024,
      'duration': 130,
      'platforms': 'Disney+',
      'cast': ['Ryan Reynolds', 'Hugh Jackman'],
      'rating': 4.7,
      'description': 'Wade Wilson se une a Wolverine en una aventura multiversal que redefine la locura.',
    },
    {
      'title': 'Dune: Parte Dos',
      'imagePath': 'https://th.bing.com/th/id/OIP.iyQy2GNDScQrF5UEiFFoTwHaKz?rs=1&pid=ImgDetMain',
      'releaseDate': 2024,
      'duration': 165,
      'platforms': 'Netflix',
      'cast': ['Timothée Chalamet', 'Zendaya'],
      'rating': 4.8,
      'description': 'Paul Atreides une fuerzas con los Fremen para vengar a su familia y salvar el universo conocido.',
    },
  ];
}

//TODO: Funció per retornar obres segons una cerca
//Funció exlusiva per fer cerques de sèries o pel·lícules segons paraules, gèneres, el director, un actor/actriu o
//una duració indicada per l'usuari amb els filtres de cerca
Future<List<Map<String, dynamic>>> getFilmsBySearch(String search, String genre, String director,
    String actor, int duration) async {
  return [
    {
      'title': 'Captain America: Brave New World',
      'imagePath': 'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
      'releaseDate': 2025,
      'duration': 119,
      'platforms': 'Disney+',
      'cast': ['Anthony Mackie', 'Harrison Ford'],
      'rating': 3.5,
      'description': 'Tras reunirse con el recién elegido presidente de EE.UU. Thaddeus Ross (Harrison Ford), '
          'Sam se encuentra en medio de un incidente internacional...',
    },];
}

//TODO: Afegir a la biblioteca de l'usuari la película a la BD
//Funció per crear una relació a la biblioteca entre un usuari i pel·lícula/sèrie de la id passada
Future<bool> addToLibrary(String title, int userId) async {
  return true;
}

//TODO: Eliminar de la biblioteca de l'usuari la película a la BD
//Funció per eliminar una relació a la biblioteca entre un usuari i pel·lícula/sèrie de la id passada
Future<bool> deleteFromLibrary(String title, int userId) async {
  return true;
}

//TODO: Modificar canvis a la biblioteca de l'usuari a la BD
//Funció per afegir o modificar el comentari, la valoració o el moment d'una pel·lícula/sèrie concreta dins
//la biblioteca d'un usuari
Future<bool> modifyFromLibrary(String title, String comment, int capitol, int minut, double rating, int userId) async {
  return true;
}

//Funció que permet agafar totes les pel·lícules o sèries d'un usuari, depenent de si la secció seleccionada
//és la de pel·lícules o la de sèries
Future<List<Map<String, dynamic>>> getLibraryFilms(int userId, bool film) async {
  //TODO: Modificar per agafar películes i sèries de la biblioteca de l'usuari de la BD
  return [
    {
      'title': 'Captain America: Brave New World',
      'imagePath': 'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
      'episode': 0,
      'timeLastSeen': 34,
      'personalRating': 4.1,
      'comment': "Really good film",
      'type': 1
    },
    {
      'title': 'Deadpool & Wolverine',
      'imagePath': 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/7229d393-c3b8-4703-a41e-e876546d2612/dgukxa3-35713cc0-ca62-46d1-be6e-bf653f78c58e.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzcyMjlkMzkzLWMzYjgtNDcwMy1hNDFlLWU4NzY1NDZkMjYxMlwvZGd1a3hhMy0zNTcxM2NjMC1jYTYyLTQ2ZDEtYmU2ZS1iZjY1M2Y3OGM1OGUuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.6unGo3zIe5tU3wjb7_JU0IX-rMOmpFVZFJrPe7onm44',
      'episode': 0,
      'timeLastSeen': 117,
      'personalRating': 5,
      'comment': 'Obra de arte espectacular',
      'type': 0
    },
    {
      'title': 'Dune: Parte Dos',
      'imagePath': 'https://th.bing.com/th/id/OIP.iyQy2GNDScQrF5UEiFFoTwHaKz?rs=1&pid=ImgDetMain',
      'episode': 0,
      'timeLastSeen': 40,
      'personalRating': 2,
      'comment': 'Better the first part.',
      'type': 1
    },
  ];
}

//TODO: Modificar funció
Future<Map<String, dynamic>?> getUser(String userId) async {
  // Exemple de dades que podria retornar (pots substituir-ho amb dades de la BD/API)
  return {
    'username': 'johndoe',
    'email': 'johndoe@example.com',
    'edat': 30,
  };
}

//Funció que permet agafar les pel·lícules o sèries recomanades de manera intel·ligent segons els
// gustos de l'usuari actual
Future<List<Map<String, dynamic>>> getRecomendationFilms(int userId) async {
  //TODO: Modificar per agafar películes i sèries de la biblioteca de l'usuari de la BD
  return [
    {
      'title': 'Captain America: Brave New World',
      'imagePath': 'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
      'episode': 0,
      'timeLastSeen': 34,
      'personalRating': 4.1,
      'comment': "Really good film",
      'type': 1
    },
    {
      'title': 'Deadpool & Wolverine',
      'imagePath': 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/7229d393-c3b8-4703-a41e-e876546d2612/dgukxa3-35713cc0-ca62-46d1-be6e-bf653f78c58e.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzcyMjlkMzkzLWMzYjgtNDcwMy1hNDFlLWU4NzY1NDZkMjYxMlwvZGd1a3hhMy0zNTcxM2NjMC1jYTYyLTQ2ZDEtYmU2ZS1iZjY1M2Y3OGM1OGUuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.6unGo3zIe5tU3wjb7_JU0IX-rMOmpFVZFJrPe7onm44',
      'episode': 0,
      'timeLastSeen': 117,
      'personalRating': 5,
      'comment': 'Obra de arte espectacular',
      'type': 0
    },
    {
      'title': 'Dune: Parte Dos',
      'imagePath': 'https://th.bing.com/th/id/OIP.iyQy2GNDScQrF5UEiFFoTwHaKz?rs=1&pid=ImgDetMain',
      'episode': 0,
      'timeLastSeen': 40,
      'personalRating': 2,
      'comment': 'Better the first part.',
      'type': 1
    },
  ];
}

//TODO: Funció per modificar informació peli/serie de cartellera
//Funció que permet passar informació modificada o nova d'una pel·lícula o sèrie
//per introduir-la a la base de dades
Future<bool> addOrModifyFilm(String title, List<String> cast, int releaseDate, int duration, List<String> platforms,
  String imagePath, int pegi, int season, int numChapters) async {
  return true;
}

//TODO: Funció per eliminar una peli/serie de cartellera
//Funció que permet eliminar una pel·lícula o sèrie de la cartellera (BD) a partir del seu títol
Future<bool> deleteFilm(String title) async {
  return true;
}

//Funció que permet agafar els questionaris disponibles de la pel·lícula o sèrie cercada de la BD
Future<List<Map<String, dynamic>>> getQuestsByFilm(String search) async {
  //TODO: Modificar per agafar questionaris i sèries de la biblioteca de l'usuari de la BD
  return [
    {
      'imagePath': 'https://1.bp.blogspot.com/-a0Ehz4tIUkA/Xla-XGLxrLI/AAAAAAAAfsM/5jCeN2T3UOMgiFSLb_U6nw0d5gXfceIbgCLcBGAsYHQ/s1600/stranger-things-saison-1.jpg',
      'title': 'Stranger Things: Season 1',
    },
    {
      'imagePath': 'https://es.web.img3.acsta.net/pictures/17/10/23/14/24/5968627.jpg',
      'title': 'Stranger Things: Season 2',
    },
    {
      'imagePath': 'https://es.web.img3.acsta.net/pictures/17/10/23/14/24/5968627.jpg',
      'title': 'Stranger Things: Season 3',
    },
  ];
}

//Funció que permet agafar 10 preguntes corresponents al questionari seleccionat anteriorment
// Simulació de dades que es poden obtenir des del backend
Future<List<Map<String, dynamic>>> getQuestions(String title) async {
  // TODO: Implementar crida real a la base de dades
  return [
    {
      'question': '¿Cuál es el personaje que desaparece en la primera temporada?',
      'possibleAnswers': ['VECNA', 'ELEVEN', 'DUSTIN', 'WILL'],
      'correctAnswer': 'WILL',
    },
    {
      'question': '¿Cómo se llama el monstruo con cara de flor?',
      'possibleAnswers': ['DEMOGORGON', 'VENOM', 'PERRY', 'VECNA'],
      'correctAnswer': 'DEMOGORGON',
    },
    {
      'question': '¿Qué personaje tiene poderes telequinéticos?',
      'possibleAnswers': ['WILL', 'HOPPER', 'ELEVEN', 'LUCAS'],
      'correctAnswer': 'ELEVEN',
    },
    {
      'question': '¿Cómo se llama la ciudad donde ocurre Stranger Things?',
      'possibleAnswers': ['HAWKINS', 'SPRINGFIELD', 'RIVERDALE', 'GOTHAM'],
      'correctAnswer': 'HAWKINS',
    },
    {
      'question': '¿Qué criatura vive en el “Upside Down”?',
      'possibleAnswers': ['DEMOGORGON', 'DRAGON', 'SLIMER', 'VECNA'],
      'correctAnswer': 'DEMOGORGON',
    },
    {
      'question': '¿Qué personaje trabaja en la policía?',
      'possibleAnswers': ['MIKE', 'STEVE', 'HOPPER', 'DUSTIN'],
      'correctAnswer': 'HOPPER',
    },
    {
      'question': '¿Cómo se llama el hermano de Will?',
      'possibleAnswers': ['MIKE', 'JONATHAN', 'DUSTIN', 'STEVE'],
      'correctAnswer': 'JONATHAN',
    },
    {
      'question': '¿Qué personaje se afeita la cabeza?',
      'possibleAnswers': ['ELEVEN', 'WILL', 'MAX', 'JOYCE'],
      'correctAnswer': 'ELEVEN',
    },
    {
      'question': '¿Quién es el líder del grupo de niños?',
      'possibleAnswers': ['MIKE', 'WILL', 'LUCAS', 'DUSTIN'],
      'correctAnswer': 'MIKE',
    },
    {
      'question': '¿Qué actriz interpreta a Joyce?',
      'possibleAnswers': ['WINONA RYDER', 'MILLIE BOBBY BROWN', 'NATALIA DYER', 'MAYA HAWKE'],
      'correctAnswer': 'WINONA RYDER',
    },
  ];
}

//Funció per aconseguir els personatges de la pel·lícula o sèrie cercada
Future<List<Map<String, dynamic>>> getCharactersBySearch(String search) async {
  // TODO: Implementar crida real a la base de dades
  return [
    {
      'name': "Eleven",
      'imagePath': "https://images.hdqwalls.com/download/stranger-things-eleven-art-nw-1280x2120.jpg",
      'context': "• Té habilitats psíquiques\n• Desconfia de la gent\n• Parla molt bé dels seus amics",
    },
    {
      'name': "Will",
      'imagePath': "https://i.pinimg.com/originals/ec/6d/59/ec6d59f48c5e8ba9b5021b68c8c401dd.jpg",
      'context': "• S'espanta molt sovint. \n• Desconfia de la gent degut a traumes del passat \n• El va raptar una altra dimensió",
    },
  ];
}

//TODO: Funció per afegir un personatge a xat
//Funció que permet afegir un personatge escollit per establir un xat amb ell/a
Future<bool> addCharacterToChat(String name) async {
  return true;
}

//TODO: Funció per afegir un personatge a xat
//Funció que permet afegir un personatge a la base de dades de personatges disponibles per establir un xat amb ell/a
Future<bool> addCharacter(String name, String imagePath, String description, String filmTitle) async {
  return true;
}