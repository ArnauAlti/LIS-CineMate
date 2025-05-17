import 'package:flutter/material.dart';
import '../requests.dart'; // Ha de contenir la funció sendMessage()

class XatPersonatge extends StatefulWidget {
  final String nomPersonatge;
  final String movieName;

  const XatPersonatge({super.key, required this.nomPersonatge, required this.movieName});

  @override
  State<XatPersonatge> createState() => _XatPersonatgeState();
}

class _XatPersonatgeState extends State<XatPersonatge> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _missatges = [];
  bool _isCharacterTyping = false;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ..._missatges.map((message) {
                      final isSelf = message['author'] == 'self';
                      final isCharacter = message['author'] == 'character';

                      return Align(
                        alignment: isSelf? Alignment.centerRight: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelf
                                ? Colors.black
                                : isCharacter
                                ? Colors.lightBlue[100]
                                : Colors.grey[300],
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
                    if (_isCharacterTyping)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "The character is writing...",
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
                      hintText: 'Write a message...',
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
      ),
    );
  }

  void _sendMessage(String messageText) {
    setState(() {
      _missatges.add({
        "author": "self",
        "message": messageText,
      });
      _isCharacterTyping = true;
      _controller.clear();
    });

    final message = sendMessage(widget.nomPersonatge, messageText);

    //TODO: Modificar per actualizar en viu amb resposta del xat
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _missatges.add({
          "author": "character",
          "message": "Resposta automàtica del personatge.",
        });
        _isCharacterTyping = false;
      });
    });
  }
}
