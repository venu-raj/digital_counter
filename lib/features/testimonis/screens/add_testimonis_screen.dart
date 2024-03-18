import 'dart:io';
import 'package:digital_counter/networking/controller/testimonis_controller.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddTestimonisScreen extends ConsumerStatefulWidget {
  const AddTestimonisScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddTestimonisScreenState();
}

class _AddTestimonisScreenState extends ConsumerState<AddTestimonisScreen> {
  final captionController = TextEditingController();
  XFile? image;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  void sharetestimonis() {
    if (image == null && captionController.text.trim().isNotEmpty) {
      ref.read(testimonisControllerProvider.notifier).shareTextTweet(
            text: captionController.text.trim(),
            context: context,
            repliedTo: "",
            repliedToUserId: "",
            ref: ref,
          );
    } else if (image != null && captionController.text.trim().isNotEmpty) {
      ref.read(testimonisControllerProvider.notifier).shareImageTweet(
            images: image!,
            text: captionController.text.trim(),
            context: context,
            repliedTo: "",
            repliedToUserId: "",
            ref: ref,
          );
    } else {
      showSnackBar(
        context,
        "Please enter caption",
        ref,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(testimonisControllerProvider);
    // final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              sharetestimonis();
            },
            child: Text(
              "Post",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Pallete.blueColor),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: image == null
                              ? IconButton(
                                  onPressed: () async {
                                    XFile file = await pickImage();
                                    setState(() {
                                      image = file;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.insert_photo_rounded,
                                    size: 25,
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: captionController,
                            decoration: const InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
