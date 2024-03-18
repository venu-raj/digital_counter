import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';

class EditProfilescreen extends ConsumerStatefulWidget {
  final UserModel userModel;
  const EditProfilescreen({
    super.key,
    required this.userModel,
  });

  @override
  ConsumerState<EditProfilescreen> createState() => _EditProfilescreenState();
}

class _EditProfilescreenState extends ConsumerState<EditProfilescreen> {
  late TextEditingController nameController;
  XFile? image;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.userModel.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(praiseControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: false,
        title: Text(
          'Edit Profile',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (image != null) {
                ref.read(praiseControllerProvider.notifier).updateUser(
                      widget.userModel.uid,
                      nameController.text.trim(),
                      image,
                      ref,
                      context,
                    );
              } else {
                ref.read(praiseControllerProvider.notifier).updateUserNameOnly(
                      widget.userModel.uid,
                      nameController.text.trim(),
                      ref,
                      context,
                    );
              }
            },
            child: Text(
              'Save ',
              style: TextStyle(
                fontSize: 18,
                color: currentTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      XFile file = await pickImage();
                      setState(() {
                        image = file;
                      });
                    },
                    child: image == null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.userModel.profilePic!,
                            ),
                            radius: 40,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(
                              File(image!.path),
                            ),
                            radius: 40,
                          ),
                  ),
                  const SizedBox(height: 14),
                  ProfileTextFeild(
                    controller: nameController,
                    labelText: 'Name *',
                    currentTheme: currentTheme,
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final ThemeData currentTheme;
  const ProfileTextFeild({
    super.key,
    required this.controller,
    required this.labelText,
    required this.currentTheme,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: currentTheme.primaryColor,
        ),
      ),
    );
  }
}
