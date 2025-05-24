import '../requests.dart';
import 'generar_recomanacions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';

class RecomanacionsScreen extends StatefulWidget {
  const RecomanacionsScreen({super.key});

  @override
  _RecomanacionsScreenState createState() => _RecomanacionsScreenState();
}

class _RecomanacionsScreenState extends State<RecomanacionsScreen> {
  late Future<List<Map<String, dynamic>>> _genresFuture;
  Map<String, bool> _genres = {}; // Inicialment buit

  @override
  void initState() {
    super.initState();
    _genresFuture = loadGenres();
  }

  Future<List<Map<String, dynamic>>> loadGenres() async {
    final genreList = await getGenres();
    setState(() {
      _genres = {
        for (var genre in genreList)
          genre['name'] as String: false
      };
    });
    print(genreList);
    return genreList;
  }

  List<String> _getSelectedGenres() {
    return _genres.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Recommendations"),
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _genresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error carregant gèneres'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Generate recommendations from:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecomanacionsGeneradesScreen(
                            selectedGenres: _getSelectedGenres(),
                            type: true,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Personal ratings"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecomanacionsGeneradesScreen(
                            selectedGenres: _getSelectedGenres(),
                            type: false,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Other users"),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Give more weight to the selected genres:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _genres.keys.map((genre) {
                      return CheckboxListTile(
                        title: Text(genre),
                        value: _genres[genre],
                        onChanged: (bool? value) {
                          setState(() {
                            _genres[genre] = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}