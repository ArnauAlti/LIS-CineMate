import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';
import 'editar_questionari.dart';

class QuestionarisDisponibles extends StatefulWidget {
  const QuestionarisDisponibles({super.key, required this.busqueda});
  final String busqueda;

  @override
  State<QuestionarisDisponibles> createState() => _QuestionarisDisponiblesState();
}

class _QuestionarisDisponiblesState extends State<QuestionarisDisponibles> {
  late Future<List<Map<String, dynamic>>> _futureQuests;

  @override
  void initState() {
    super.initState();
    _futureQuests = getQuestsByFilm(widget.busqueda);
  }

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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureQuests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se han encontrado cuestionarios de ${widget.busqueda}.'));
          }

          final cuestionarios = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qüestionaris sobre:\n${widget.busqueda}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                for (final q in cuestionarios) ...[
                  _buildQuestionariItem(context, userRole, q),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionariItem(BuildContext context, String userRole,
      Map<String, dynamic> quest) {
    final imageUrl = quest['imagePath']!;
    final title = quest['title']!;

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
                  child: const Text("EDITAR "),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await deleteQuestionnaire(title);

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
                  child: const Text("ELIMINAR"),
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
