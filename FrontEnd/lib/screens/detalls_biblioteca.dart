import 'package:cine_mate/requests.dart';
import 'package:cine_mate/screens/biblioteca.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_role_provider.dart';

class DetallsBibliotecaScreen extends StatefulWidget {
  final Map<String, dynamic> film;

  const DetallsBibliotecaScreen({super.key, required this.film});

  @override
  State<DetallsBibliotecaScreen> createState() => _DetallsBibliotecaScreenState();
}

class _DetallsBibliotecaScreenState extends State<DetallsBibliotecaScreen> {
  double selectedRating = 0;
  final TextEditingController comentariController = TextEditingController();
  String selectedStatus = 'Not yet started';

  final List<String> statusOptions = ['Not yet started', 'In progress', 'Seen'];

  @override
  void initState() {
    super.initState();

    final film = widget.film;
    selectedRating = (film['rating'] ?? 0.0).toDouble();
    comentariController.text = film['comment'] ?? '';
    selectedStatus = film['status'] ?? 'Not yet started';
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;
    final mail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              film["media_name"] ?? "No title",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  film["media_png"] ??
                      'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
                  width: 180,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Current state",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                IconData icon;
                if (selectedRating >= starValue) {
                  icon = Icons.star;
                } else if (selectedRating >= starValue - 0.5) {
                  icon = Icons.star_half;
                } else {
                  icon = Icons.star_border;
                }

                return Column(
                  children: [
                    IconButton(
                      icon: Icon(icon, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (selectedRating == starValue.toDouble()) {
                            selectedRating = starValue - 0.5;
                          } else {
                            selectedRating = starValue.toDouble();
                          }
                        });
                      },
                    ),
                    Text("$starValue"),
                  ],
                );
              }),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Comment",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: comentariController,
              cursorColor: Colors.black,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter your comment/opinion",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final String comment = comentariController.text;
                final double rating = selectedRating;
                final String status = selectedStatus;

                final success = await modifyFromLibrary(mail!, film['media_id'], film['info_id'], comment, status, rating);

                if (success){
                  setState(() {
                    widget.film['comment'] = comment;
                    widget.film['personalRating'] = rating;
                    widget.film['status'] = status;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes have been saved.')),
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BibliotecaScreen(),
                      )
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save the changes.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Save changes"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final success = await deleteFromLibrary(mail!, film['media_id'], film['info_id']);
            if (success){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BibliotecaScreen(),
                )
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unable to delete from library.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text("Delete from library"),
        ),
      ),
    );
  }
}
