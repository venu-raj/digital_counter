import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerWidget {
  final String verificationId;
  const OTPScreen({
    super.key,
    required this.verificationId,
  });

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(praiseControllerProvider.notifier).verifyOTP(
          context: context,
          verificationId: verificationId,
          userOTP: userOTP,
          ref: ref,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isLoading = ref.watch(praiseControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
      ),
      body: isLoading
          ? const LoadingPage()
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('We have sent an SMS with a code.'),
                  SizedBox(
                    width: size.width * 0.5,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: '- - - - - -',
                        hintStyle: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        if (val.length == 6) {
                          verifyOTP(ref, context, val.trim());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
