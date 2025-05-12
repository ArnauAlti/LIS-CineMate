import 'package:flutter/material.dart';
import 'app_drawer.dart';
import '../user_role_provider.dart';
import 'package:provider/provider.dart';

class ManualUsScreen extends StatefulWidget {
  const ManualUsScreen({super.key});

  @override
  State<ManualUsScreen> createState() => _ManualUsScreen();
}

class _ManualUsScreen extends State<ManualUsScreen> {
  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    var userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("User's manual", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExpansionTile(
              icon: Icons.library_books,
              title: "How does the library work?",
              content:
              "The library is the section where you can save all the series and movies you have watched or want to watch, divided into two corresponding sections. "
                  "You can rate and comment on works saved in the library, but only you will be able to see them. You can also save the exact moment you left off, "
                  "in case you want to resume later. For series, you can also specify the episode.\n\n"
                  "How to save a movie or series in the library?\n"
                  "→ Go to the catalog section, open the movie or series you want, and click 'Add to library'.\n\n"
                  "Can I delete movies or series from the library?\n"
                  "→ Yes, just open the movie/series in your library and click the delete button.\n\n"
                  "Can I modify the comment or rating?\n"
                  "→ Yes, open the relevant movie or series, change the rating, comment, or resume point, and click 'Save changes'.",
            ),
            _buildExpansionTile(
              icon: Icons.recommend,
              title: "How do recommendations work?",
              content:
              "Smart recommendations will show you movies and series that best match your preferences. "
                  "You can also generate recommendations based on the tastes of other users you follow.\n\n"
                  "Can I give more weight to a certain genre?\n"
                  "→ Yes, you can choose which genres to prioritize when generating recommendations.",
            ),
            _buildExpansionTile(
              icon: Icons.quiz,
              title: "How do quizzes work?",
              content: "With quizzes, you can test your knowledge about the movie or series of your choice. "
            "Search for the movie or series you want and click start. Ten random questions will be generated, but only five will appear.\n\n"
            "Can I leave the quiz if I no longer want to continue?\n"
            "→ Yes, you can exit the quiz at any time using the appropriate button or leave after the first five questions.",
            ),
            _buildExpansionTile(
              icon: Icons.chat_bubble,
              title: "How do smart chats work?",
              content:
              "Chats allow you to talk with characters from your favorite movies or series. Although they are intelligent, they do not remember past conversations after several hours. "
                  "They generate responses based on the character's personality.\n\n"
                  "How do I add a new chat?\n"
                  "→ Click 'Add new chat', search for the character or movie/series, and it will automatically be added to the active chats list.\n\n"
                  "What if I have 3 active chats and want to start a new one?\n"
                  "→ You must delete a chat using the 'Delete chats' option and select the one you want to remove.",
            ),
            _buildExpansionTile(
              icon: Icons.people,
              title: "How does the social feature work?",
              content:
              "In the 'Other Users' section, you can see the people you follow and their respective libraries, including comments and ratings. "
                  "These users also influence your personalized recommendations.\n\n"
                  "How do I follow other users?\n"
                  "→ Tap 'Search users', enter their name, go to their profile, and click 'Follow user'.\n\n"
                  "And how do I unfollow someone?\n"
                  "→ Go to their profile and click 'Unfollow'.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
