import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';

//TODO: En el futur, actualitzar xat en viu
class XatPersonatge extends StatefulWidget {
  final String nomPersonatge;
  final int userId;

  const XatPersonatge({super.key, required this.nomPersonatge, required this.userId});

  @override
  State<XatPersonatge> createState() => _XatPersonatgeState();
}

class _XatPersonatgeState extends State<XatPersonatge> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _missatges = [];

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.nomPersonatge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getMessagesByChat(userEmail!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final messages = snapshot.data ?? _missatges; // Utilizamos los mensajes del estado
          final lastMessageIsMine = messages.isNotEmpty && messages.last['author'] == 'self';

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        // Mostrar los mensajes
                        ...messages.map((message) {
                          final isSelf = message['author'] == 'self';
                          return Align(
                            alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelf ? Colors.black : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                message['message']!,
                                style: TextStyle(
                                  color: isSelf ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Si el último mensaje es mío, mostrar indicador de que el personaje está escribiendo
                        if (lastMessageIsMine)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "El personaje está escribiendo...",
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessage(_controller.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Función para enviar el mensaje
  void _sendMessage(String messageText) {
    setState(() {
      _missatges.add({
        "author": "self", // Es el mensaje del usuario
        "message": messageText,
      });
      _controller.clear(); // Limpiar el campo de texto después de enviar el mensaje
    });
  }
}