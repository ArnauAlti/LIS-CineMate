import 'package:cine_mate/screens/biblioteca_usuaris_seguits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../requests.dart';
import '../user_role_provider.dart';

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
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    super.initState();
    _usersFuture = getUsersBySearch(widget.busqueda, userEmail!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Other users", textAlign: TextAlign.center),
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

            print(users);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Text("Results of the search: ${widget.busqueda}",
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
    final String userMail = user['mail']?? "";
    print(userMail);
<<<<<<< HEAD
<<<<<<< HEAD
    final String nick = user['nick']?? "Unknown nickname";
=======
    final String nick = user['nick']?? "";
>>>>>>> 9a94606 (Canvis en biblioteca)
=======
    final String nick = user['nick']?? "Unknown nickname";
>>>>>>> a1107c0 (Traducció a l'anglès feta)
    final String png = (user['png'] != null && user['png'].toString().trim().isNotEmpty)
        ? user['png']
        : "assets/perfil1.jpg";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliotecaSeguitsScreen(userMail: userMail, userNick: nick, follows: false),
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
                  backgroundImage: AssetImage(png),
                ),
                const SizedBox(height: 8),
                Text(nick),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
