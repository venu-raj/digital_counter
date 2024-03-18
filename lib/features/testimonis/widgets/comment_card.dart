import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:digital_counter/models/comment_model.dart';
import 'package:digital_counter/models/testimonis_model.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/networking/controller/testimonis_controller.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';

class CommentCard extends ConsumerWidget {
  final CommentModel commentModel;
  final TestimonisModel testimonisModel;
  const CommentCard({
    super.key,
    required this.commentModel,
    required this.testimonisModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(commentModel.profilePic),
              ),
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${commentModel.userName}  ",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeago.format(commentModel.datePublished,
                            locale: 'en_short'),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: currentTheme.dividerColor,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    "${commentModel.text} ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .watch(testimonisControllerProvider.notifier)
                      .likeTheComments(
                        testimonisId: testimonisModel.id,
                        commentDocid: commentModel.commentId,
                        likes: commentModel.likes,
                        uid: user.uid,
                      );
                },
                child: commentModel.likes.contains(user.uid)
                    ? Icon(
                        CupertinoIcons.heart_fill,
                        color: Pallete.redColor,
                      )
                    : Icon(
                        CupertinoIcons.heart,
                        color: currentTheme.dividerColor,
                      ),
              ),
              Text(
                commentModel.likes.length.toString(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
