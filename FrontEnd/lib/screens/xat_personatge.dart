import 'package:flutter/material.dart';

class XatPersonatge extends StatelessWidget {
  final String nomPersonatge;

  const XatPersonatge({super.key, required this.nomPersonatge});

  @override
  Widget build(BuildContext context) {
    // TODO: Agafar missatges de la BD per afegir-los a la conversa
    final List<Map<String, String>> missatges = [
      {"autor": "Jo", "text": "Com vas descobrir l’últim assassí?"},
      {
        "autor": "Sherlock",
        "text": "El vaig descobrir perquè portava un llibre estrany."
      },
      {"autor": "Sherlock", "text": "Li vaig treure, i era sobre verins."},
      {
        "autor": "Sherlock",
        "text": "Hi havia sang a la part del verí que va matar a la víctima."
      },
    ];

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(nomPersonatge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: missatges.length,
          itemBuilder: (context, index) {
            final missatge = missatges[index];
            final esMeu = missatge['autor'] == "Jo";

            return Align(
              alignment:
              esMeu ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: esMeu ? Colors.black : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  missatge['text']!,
                  style: TextStyle(
                    color: esMeu ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
