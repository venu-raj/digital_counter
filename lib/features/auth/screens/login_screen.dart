import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(praiseControllerProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              ref
                  .read(praiseControllerProvider.notifier)
                  .signInAsGuest(context: context, ref: ref);
            },
            child: Text(
              "Skip",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: currentTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'We need to verify your phone number',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: currentTheme.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please enter your 10 digits phone number',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: currentTheme.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 5,
                          ),
                          child: Text(
                            '+91',
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: 'phone number',
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String phoneNumber = phoneController.text.trim();
                      if (phoneNumber.length == 10) {
                        ref
                            .read(praiseControllerProvider.notifier)
                            .loginWithUser(
                              phoneNumber: '+91$phoneNumber',
                              context: context,
                            );
                      } else {
                        showSnackBar(
                          context,
                          "Please enter valid number",
                          ref,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      minimumSize: Size(MediaQuery.of(context).size.width, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "NEXT",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
