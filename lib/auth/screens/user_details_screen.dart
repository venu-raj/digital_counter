import 'package:digital_counter/common/loader.dart';
import 'package:digital_counter/common/utils.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  late TextEditingController phoneController;
  final nameController = TextEditingController();

  @override
  void initState() {
    phoneController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
    );
    super.initState();
  }

  void uploadUserToFirebase() {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(praiseControllerProvider.notifier)
          .uploadUserToFirebase(name: name, context: context);
    } else {
      showSnackBar(
        context,
        "Please fill valid Username",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(praiseControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Full Name *',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.grey.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 17),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.grey.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 17),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: uploadUserToFirebase,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      child: const Text(
                        "COMPLETE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
