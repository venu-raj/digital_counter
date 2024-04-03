import 'package:digital_counter/utils/common/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:digital_counter/features/testimonis/screens/comment_screen.dart';
import 'package:digital_counter/models/testimonis_model.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/networking/controller/testimonis_controller.dart';
import 'package:digital_counter/utils/enums/testimoni_type.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:digital_counter/utils/theme/pallete.dart';

class TestimonisCard extends ConsumerWidget {
  final TestimonisModel testimonisModel;
  const TestimonisCard({
    super.key,
    required this.testimonisModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    Future<void> sharToWhatsApp() async {
      final box = context.findRenderObject() as RenderBox?;
      return await Share.share(
        "${testimonisModel.imageLinks}\n${testimonisModel.text}",
        subject: "",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  testimonisModel.profilePic,
                ),
                radius: 18,
              ),
              const SizedBox(width: 4),
              Text(
                testimonisModel.userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        testimonisModel.testimoniType == TestimoniType.image
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      testimonisModel.imageLinks,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress != null) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: currentTheme.primaryColor,
                              ),
                            ),
                          );
                        } else {
                          return child;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      testimonisModel.text,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  testimonisModel.text,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                      return showSnackBar(context,
                          "Please Login to like the testimonials", ref);
                    } else {
                      ref
                          .read(testimonisControllerProvider.notifier)
                          .likeThePost(
                            testimonisId: testimonisModel.id,
                            likes: testimonisModel.likes,
                            uid: user.uid,
                          );
                    }
                  },
                  icon: testimonisModel.likes.contains(user.uid)
                      ? Icon(
                          CupertinoIcons.heart_fill,
                          color: Pallete.redColor,
                        )
                      : Icon(
                          CupertinoIcons.heart,
                          color: currentTheme.primaryColor,
                        ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CommentScreen(
                          testimonisModel: testimonisModel,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.comment_outlined,
                    color: currentTheme.primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                      return showSnackBar(context,
                          "Please Login to share the testimonials", ref);
                    } else {
                      sharToWhatsApp();
                    }
                  },
                  icon: Icon(
                    CupertinoIcons.share,
                    color: currentTheme.primaryColor,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "${testimonisModel.likes.length.toString()} likes",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                timeago.format(testimonisModel.createdAt),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: currentTheme.dividerColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(
          color: currentTheme.dividerColor.withOpacity(0.2),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
