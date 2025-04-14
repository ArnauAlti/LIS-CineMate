import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';
import 'editar_questionari.dart';

class QuestionarisDisponibles extends StatelessWidget {
  const QuestionarisDisponibles({super.key, required this.busqueda});
  final String busqueda;

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Cuestionarios"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qüestionaris sobre:\n$busqueda',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              _buildQuestionariItem(
                context,
                userRole,
                imageUrl:
                'https://1.bp.blogspot.com/-a0Ehz4tIUkA/Xla-XGLxrLI/AAAAAAAAfsM/5jCeN2T3UOMgiFSLb_U6nw0d5gXfceIbgCLcBGAsYHQ/s1600/stranger-things-saison-1.jpg',
                title: 'Stranger Things: Season 1',
              ),
              const SizedBox(height: 30),
              _buildQuestionariItem(
                context,
                userRole,
                imageUrl:
                'https://es.web.img3.acsta.net/pictures/17/10/23/14/24/5968627.jpg',
                title: 'Stranger Things: Season 2',
              ),
              const SizedBox(height: 30),
              _buildQuestionariItem(
                context,
                userRole,
                imageUrl:
                'https://es.web.img3.acsta.net/pictures/17/10/23/14/24/5968627.jpg',
                title: 'Stranger Things: Season 2',
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildQuestionariItem(BuildContext context, String userRole,
      {required String imageUrl, required String title}) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          imageUrl,
          height: 180,
          width: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              if (userRole == "Administrador") ... [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuestionariAdminScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Editar"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Eliminar qüestionari
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Qüestionari eliminat.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Eliminar"),
                ),
              ] else ... [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/pregunta_questionari',
                      arguments: {'title': title},
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
                  child: const Text("COMENZAR"),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
