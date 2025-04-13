import 'package:flutter/material.dart';
import 'afegir_personatge.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO: Modificar per posar els personatges segons la cerca
            const Text(
              "Personatges disponibles de: Stranger Things",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                //TODO: Personatges segons cerca
                children: [
                  buildCharacterCard(
                    context,
                    name: "Eleven",
                    imageUrl:
                    "https://images.hdqwalls.com/download/stranger-things-eleven-art-nw-1280x2120.jpg",
                  ),
                  buildCharacterCard(
                    context,
                    name: "Will",
                    imageUrl:
                    "https://i.pinimg.com/originals/ec/6d/59/ec6d59f48c5e8ba9b5021b68c8c401dd.jpg",
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AfegirPersonatgeScreen()));
        },
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
            builder: (context) => const InfoPersonatgeAdmin(),
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
