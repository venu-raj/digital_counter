import 'package:digital_counter/utils/common/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/features/testimonis/widgets/comment_card.dart';
import 'package:digital_counter/models/testimonis_model.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/networking/controller/testimonis_controller.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/theme/pallete.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final TestimonisModel testimonisModel;
  const CommentScreen({
    super.key,
    required this.testimonisModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: ref.watch(getCommentsProvider(widget.testimonisModel.id)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final comment = data[index];
                  return CommentCard(
                    commentModel: comment,
                    testimonisModel: widget.testimonisModel,
                  );
                },
              );
            },
            error: (error, st) {
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Loader(),
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 12, right: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic!),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment as ${user.name}',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                ),
              ),
            ),
            IconButton.filled(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                  return showSnackBar(context, "Please Login to comment", ref);
                } else {
                  if (commentController.text.trim().isNotEmpty) {
                    ref.read(testimonisControllerProvider.notifier).postComment(
                          postId: widget.testimonisModel.id,
                          text: commentController.text.trim(),
                          ref: ref,
                        );

                    commentController.text = "";
                  }
                }
              },
              color: Pallete.whiteColor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.blueColor,
              ),
              icon: const Icon(Icons.arrow_upward),
            ),
          ],
        ),
      ),
    );
  }
}
