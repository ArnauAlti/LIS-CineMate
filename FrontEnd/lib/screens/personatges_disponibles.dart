import 'package:flutter/material.dart';
import 'afegir_personatge_admin.dart';
import 'info_personatge.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import '../requests.dart';

class PersonatgesDisponiblesScreen extends StatelessWidget {
  final String title;

  const PersonatgesDisponiblesScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

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
        future: getPersonatges(title), // Aquí haces la llamada a la función
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No s’han trobat personatges.'));
          }

          final personatges = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Personatges disponibles de: $title",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: personatges.map((personatge) {
                    return buildCharacterCard(
                      context,
                      name: personatge['name'] ?? 'Desconegut',
                      imageUrl: personatge['imagePath'] ?? '',
                      description: personatge['description'] ?? '',
                    );
                  }).toList(),
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
            MaterialPageRoute(builder: (context) => const AfegirPersonatgeScreen()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null, // No mostris cap botó si no és administrador


    );
  }

  Widget buildCharacterCard(BuildContext context,
      {required String name, required String imageUrl, required String description}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPersonatge(
              name: name,
              imageUrl: imageUrl,
              description: description,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(name),
        ],
      ),
    );
  }
}
