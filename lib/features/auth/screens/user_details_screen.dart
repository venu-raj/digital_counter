import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/common/utils.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  final String? nullableName;
  const UserDetailsScreen({
    super.key,
    this.nullableName,
  });

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  late TextEditingController phoneController;
  late TextEditingController nameController;

  @override
  void initState() {
    phoneController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
    );
    nameController = TextEditingController(text: widget.nullableName);
    super.initState();
  }

  void uploadUserToFirebase() {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(praiseControllerProvider.notifier)
          .uploadUserToFirebase(name: name, context: context, ref: ref);
    } else {
      showSnackBar(
        context,
        "Please fill valid Username",
        ref,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(praiseControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your details'),
        elevation: 0,
      ),
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Full Name *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: uploadUserToFirebase,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue.withOpacity(0.8),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "COMPLETE",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
