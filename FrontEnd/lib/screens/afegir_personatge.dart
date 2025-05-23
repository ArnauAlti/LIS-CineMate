import 'package:cine_mate/screens/cerca_personatges.dart';
import 'package:flutter/material.dart';
import '../requests.dart';

class AfegirPersonatgeScreen extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? charData;


  const AfegirPersonatgeScreen({
    super.key,
    required this.mode,
    this.charData,
  });

  @override
  State<AfegirPersonatgeScreen> createState() => _AfegirPersonatgeScreen();
}

class _AfegirPersonatgeScreen extends State<AfegirPersonatgeScreen> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController imagePathController;
  late final TextEditingController MediaIdController;

  @override
  void initState() {
    super.initState();
    final data = widget.charData;

    nameController = TextEditingController(text: data?['name'] ?? "");
    descriptionController = TextEditingController(text: data?['context'] ?? "");
    imagePathController =
        TextEditingController(text: data?["imagePath"] ?? "");
    MediaIdController =
        TextEditingController(text: data?["movie_name"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.mode == "New" ? "Add character" : "Edit Character"),
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
                child: Text("Character's name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
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
                child: Text("Image's URL"),
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

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Description"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Film or Series of the Character"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: MediaIdController,
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
                    if (widget.mode == "New") {
                      await addCharacter(
                        nameController.text,
                        imagePathController.text,
                        descriptionController.text,
                        MediaIdController.text,
                      );
                    } else {
                      await modifyCharacter(
                        nameController.text,
                        imagePathController.text,
                        descriptionController.text,
                        MediaIdController.text,
                      );
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CercaPersonatgesScreen(),
                      ),
                    );

                    final String accion = widget.mode == "New" ? "Added" : "Saved";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${nameController.text} has been $accion on the database.')),
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
                  child: Text(widget.mode == "New" ? "Add" : "Save"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
      ),
    );
  }
}