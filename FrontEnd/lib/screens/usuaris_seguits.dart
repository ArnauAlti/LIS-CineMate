import 'package:cine_mate/screens/cerca_usuaris.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';
import '../requests.dart';
import 'biblioteca_usuaris_seguits.dart';

class UsuarisSeguits extends StatefulWidget {
  const UsuarisSeguits({super.key});

  @override
  State<UsuarisSeguits> createState() => _UsuarisSeguits();
}

class _UsuarisSeguits extends State<UsuarisSeguits> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    super.initState();
    _usersFuture = getUsersByUserMail(userEmail!);
  }

  @override
  Widget build(BuildContext context) {
    //Agafar el rol actual per mostrar diferents drawers depenent del rol
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Followed users", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
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
                  const Text("Users you follow",
                    style: TextStyle(
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CercaUsuarisScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text("Search users"),
        ),
      ),
    );
  }

  Widget _buildUserBox(BuildContext context, Map<String, dynamic> user) {
    final String userMail = user['dst_mail']?? "";
    final String nick = user['name']?? "";
    final String png = (user['png'] != null && user['png'].toString().trim().isNotEmpty)
        ? user['png']
        : "assets/perfil1.jpg";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliotecaSeguitsScreen(userMail: userMail, userNick: nick ,follows: true),
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
