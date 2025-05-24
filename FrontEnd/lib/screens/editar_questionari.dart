import 'package:cine_mate/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';


class QuestionariAdminScreen extends StatefulWidget {
  final String mediaId;
  final String title;

  const QuestionariAdminScreen({super.key, required this.mediaId, required this.title});

  @override
  State<QuestionariAdminScreen> createState() => _QuestionariAdminScreenState();
}

class _QuestionariAdminScreenState extends State<QuestionariAdminScreen> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<Map<String, dynamic>> editableQuestions = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = getQuestions(widget.mediaId, true);
    _questionsFuture.then((questions) {
      setState(() {
        editableQuestions = questions.map((q) {
          return {
            'id': q['id'],
            'info_id': q['info_id'],
            'controller': TextEditingController(text: q['question']),
            'answers': (q['possibleAnswers'] as List?)?.cast<String>().map((a) => TextEditingController(text: a)).toList() ?? [],
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final user = userRoleProvider.getUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (editableQuestions.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: editableQuestions.length,
              itemBuilder: (context, i) => _buildEditableQuestion(i),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: ElevatedButton(
          onPressed: () async {
            final updatedQuestions = editableQuestions.map((q) {
              return {
                'id': q['id'],
                'info_id': q['info_id'],
                'question': q['controller'].text,
                'possibleAnswers': (q['answers'] as List<TextEditingController>).map((c) => c.text).toList(),
              };
            }).toList();

            await editQuestionnaire(widget.mediaId, user?['mail'], user?['nick'], user?['pass'], updatedQuestions);
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: const Text("Save changes"),
        ),
      ),
    );
  }

  Widget _buildEditableQuestion(int index) {
    final questionData = editableQuestions[index];
    final TextEditingController questionController = questionData['controller'];
    final List<TextEditingController> answerControllers = questionData['answers'];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Question ${index + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: "The question is..."),
            ),
            const SizedBox(height: 10),
            const Text("Answers:", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            ...answerControllers.asMap().entries.map((entry) {
              final i = entry.key;
              final controller = entry.value;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(labelText: "Answer ${i + 1}"),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}