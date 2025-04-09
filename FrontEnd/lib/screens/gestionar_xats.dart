import 'package:flutter/material.dart';
class GestioXats extends StatefulWidget {

  const GestioXats({super.key});

  @override
  State<GestioXats> createState() => _GestioXats();
}

class _GestioXats extends State<GestioXats> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Eliminar chats"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                //TODO: Afegir xats actius a partir de la BD
                _buildChatItem(
                  context,
                  name: "Sherlock Holmes",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context, {
        required String name,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black87,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Afegir lògica per eliminar xat de la BD
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chat con $name eliminado.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("ELIMINAR CHAT"),
          ),
        ],
      ),
    );
  }


}
