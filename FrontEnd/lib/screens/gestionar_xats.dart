import 'package:cine_mate/screens/xats_actius.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';

class GestioXats extends StatefulWidget {
  const GestioXats({super.key});

  @override
  State<GestioXats> createState() => _GestioXats();
}

class _GestioXats extends State<GestioXats> {
  late Future<List<Map<String, dynamic>>> chatsFuture;

  @override
  void initState() {
    super.initState();
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    chatsFuture = getChatsByUserMail(userEmail!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Delete chats"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data ?? [];

          return Column(
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return _buildChatItem(
                      context,
                      name: chat['name'],
                      imagePath: chat['imagePath'],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context, {
        required String name,
        required String imagePath,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(imagePath),
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
            onPressed: () async {
              final validation = await deleteChat(name);

              if(validation) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Chat with $name deleted.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const XatsActiusScreen(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Delete chat"),
          ),
        ],
      ),
    );
  }


}
