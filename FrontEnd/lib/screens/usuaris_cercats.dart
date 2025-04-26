import 'package:cine_mate/screens/biblioteca_usuaris_seguits.dart';
import 'package:flutter/material.dart';

import '../requests.dart';

class UsuarisCercats extends StatefulWidget {
  final String busqueda;

  const UsuarisCercats({super.key, required this.busqueda});

  @override
  State<UsuarisCercats> createState() => _UsuarisCercats();
}

class _UsuarisCercats extends State<UsuarisCercats> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    //TODO: Canviar id que es passa a la request
    _usersFuture = getUsersBySearch(widget.busqueda);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Otros usuarios", textAlign: TextAlign.center),
        centerTitle: true,
      ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final users = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Text("Resultados de la búsqueda: ${widget.busqueda}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    for (int i = 0; i < users.length; i += 2)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildUserBox(context, users[i]),
                              if (i + 1 < users.length)
                                _buildUserBox(context, users[i + 1]),
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  //Funció per construir la caixa tàctil de cada usuari cercat
  Widget _buildUserBox(BuildContext context, Map<String, dynamic> user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliotecaSeguitsScreen(userName: user['nick'], follows: false),
          ),
        );
      },

      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black87,
                  backgroundImage: AssetImage(user['imagePath']),
                ),
                const SizedBox(height: 8),
                Text(user['nick']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
