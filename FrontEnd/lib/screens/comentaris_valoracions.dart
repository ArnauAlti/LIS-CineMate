import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';

class CommentRatingScreen extends StatefulWidget {
  final String mediaId;
  final String infoId;

  const CommentRatingScreen({super.key, required this.mediaId, required this.infoId});

  @override
  State<CommentRatingScreen> createState() => _CommentRatingScreen();
}

class _CommentRatingScreen extends State<CommentRatingScreen> {
  late Future<List<Map<String, dynamic>>> _commentsFuture;

  @override
  void initState() {
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;

    super.initState();
    _commentsFuture = getRatingsByFilm(userEmail!, widget.mediaId, widget.infoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Other users' ratings"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final comments = snapshot.data ?? [];

          if (comments.isEmpty) {
            return const Center(child: Text('There are no ratings yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: comments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _BlurredCommentCard(comment: comments[index]);
            },
          );
        },
      ),
    );
  }
}

<<<<<<< HEAD
class _BlurredCommentCard extends StatefulWidget {
  final Map<String, dynamic> comment;
=======
  Widget _buildCommentCard(Map<String, dynamic> comment) {
    final String nickName = comment['nick'] ?? 'Unknown nickname';
    final String comentari = comment['comment'] ?? 'No comment';
    final double rating = (comment['rating'] ?? 0).toDouble();
>>>>>>> a1107c0 (Traducció a l'anglès feta)

  const _BlurredCommentCard({required this.comment});

  @override
  State<_BlurredCommentCard> createState() => _BlurredCommentCardState();
}

class _BlurredCommentCardState extends State<_BlurredCommentCard> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final String nickName = widget.comment['nick'] ?? 'Unknown nickname';
    final String comentari = widget.comment['comment'] ?? 'No comment';
    final double rating = (widget.comment['rating'] ?? 0).toDouble();

    return GestureDetector(
      onTap: () {
        setState(() {
          _revealed = true;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              _buildRatingStars(rating),
              const SizedBox(height: 12),

              // Comentario con desenfoque si no revelado
              Stack(
                children: [
                  Text(
                    comentari,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (!_revealed)
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: const Text(
                              "Spoiler Alert! Tap to reveal",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;

        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return Icon(
          icon,
          color: Colors.amber,
        );
      }),
    );
  }
}
