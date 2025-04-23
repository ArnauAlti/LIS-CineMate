import 'package:cine_mate/requests.dart';
import 'package:flutter/material.dart';
import 'afegir_personatge.dart';
import 'info_personatge.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';

class PersonatgesDisponiblesScreen extends StatefulWidget {
  const PersonatgesDisponiblesScreen({super.key, required this.busqueda});
  final String busqueda;

  @override
  State<PersonatgesDisponiblesScreen> createState() =>
      _PersonatgesDisponiblesScreen();
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
    final userRole = Provider.of<UserRoleProvider>(context).userRole;

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
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No s\'han trobat personatges.'));
          }

          final characters = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Personatges disponibles de: ${widget.busqueda}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final char = characters[index];
                    return buildCharacterCard(context, char);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: userRole == "Administrador"
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AfegirPersonatgeScreen(),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  Widget buildCharacterCard(BuildContext context, Map<String, dynamic> char) {
    final name = char['name'] ?? 'Nom no disponible';
    final imagePath = char['imagePath'] ?? '';
    final contextInfo = char['context'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPersonatge(
              name: name,
              imagePath: imagePath,
              contextInfo: contextInfo,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
