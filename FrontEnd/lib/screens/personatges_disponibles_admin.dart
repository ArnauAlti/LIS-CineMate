import 'package:flutter/material.dart';
import 'info_personatge_admin.dart';

class PersonatgesDisponiblesAdminScreen extends StatelessWidget {
  const PersonatgesDisponiblesAdminScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Personatges disponibles de: Stranger Things",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  buildCharacterCard(
                    context,
                    name: "Eleven",
                    imageUrl:
                    "https://upload.wikimedia.org/wikipedia/en/f/f7/Eleven_%28Stranger_Things%29.png",
                  ),
                  buildCharacterCard(
                    context,
                    name: "Will",
                    imageUrl:
                    "https://i.pinimg.com/originals/4c/13/38/4c13381ad89ce5cfbaf4d223c21be7c5.jpg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildCharacterCard(BuildContext context,
      {required String name, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPersonatgeAdmin(),
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
