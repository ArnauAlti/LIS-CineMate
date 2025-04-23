import 'package:cine_mate/screens/cerca_personatges.dart';
import 'package:flutter/material.dart';
import '../requests.dart';

class AfegirQuestionariScreen extends StatefulWidget {
  const AfegirQuestionariScreen({super.key});

  @override
  State<AfegirQuestionariScreen> createState() => _AfegirQuestionariScreen();
}

class _AfegirQuestionariScreen extends State<AfegirQuestionariScreen> {
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Añadir cuestionario a una película o serie"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Nombre de la película o serie"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("URL de la imagen"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: imagePathController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const Spacer(),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await addQuestionnaire(titleController.text, imagePathController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CercaPersonatgesScreen(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('El cuestionario de ${titleController.text} ha sido añadido a la base de datos.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text("Añadir"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
      ),
    );
  }
}