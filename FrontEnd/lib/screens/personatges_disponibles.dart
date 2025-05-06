import 'package:cine_mate/requests.dart';
import 'package:flutter/material.dart';
import 'info_personatge.dart';

class PersonatgesDisponiblesScreen extends StatefulWidget {
  const PersonatgesDisponiblesScreen({super.key, required this.busqueda});
  final String busqueda;

  @override
  State<PersonatgesDisponiblesScreen> createState() => _PersonatgesDisponiblesScreen();
}

class _PersonatgesDisponiblesScreen extends State<PersonatgesDisponiblesScreen> {
  late Future<List<Map<String, dynamic>>> _futureCharacters;

  @override
  void initState() {
    super.initState();
    _futureCharacters = getCharactersBySearch(widget.busqueda);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Personatges disponibles"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final characters = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  const Text("Personajes disponibles!!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  for (int i = 0; i < characters.length; i += 2)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCharacterCard(context, characters[i]),
                            if (i + 1 < characters.length)
                              buildCharacterCard(context, characters[i + 1]),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCharacterCard(BuildContext context, Map<String, dynamic> char) {
    final name = char['name'] ?? 'Nom no disponible';
    final imagePath = char['png'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPersonatge(charData: char),
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imagePath.isNotEmpty
                  ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              )
                  : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
