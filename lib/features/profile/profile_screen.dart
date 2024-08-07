import 'package:digital_counter/features/auth/screens/login_screen.dart';
import 'package:digital_counter/features/daily_verse/daily_verse_controller.dart';
import 'package:digital_counter/features/profile/edit_profile_screen.dart';
import 'package:digital_counter/utils/common/custom_button.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:digital_counter/networking/controller/praise_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void toggleTheme() {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  final dailyVerseController = TextEditingController();

  @override
  void dispose() {
    dailyVerseController.dispose();
    super.dispose();
  }

  void logOutUser() {
    ref.read(praiseControllerProvider.notifier).signOutUser();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FirebaseAuth.instance.currentUser!.isAnonymous
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.phoneNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic!),
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: FirebaseAuth.instance.currentUser!.isAnonymous
                    ? CustomButton(
                        width: MediaQuery.of(context).size.width,
                        text: "Sign In",
                        currentTheme: currentTheme,
                        onpressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      )
                    : CustomButton(
                        width: MediaQuery.of(context).size.width,
                        text: "Edit Profile",
                        currentTheme: currentTheme,
                        onpressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => EditProfilescreen(
                                userModel: user,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Settings & Preferences',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: InkWell(
                      onTap: () => toggleTheme,
                      child: ListTile(
                        tileColor: currentTheme.cardColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          side: BorderSide.none,
                        ),
                        title: const Text(
                          "Dark Theme",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        leading: const Icon(
                          Icons.dark_mode,
                        ),
                        trailing: Switch.adaptive(
                          value:
                              ref.watch(themeNotifierProvider.notifier).mode ==
                                  ThemeMode.dark,
                          onChanged: (val) => toggleTheme(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: InkWell(
                      onTap: logOutUser,
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          side: BorderSide.none,
                        ),
                        title: Text(
                          "Log out",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Pallete.redColor,
                          ),
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: Pallete.redColor,
                        ),
                      ),
                    ),
                  ),
                  user.isAdmin
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              TextField(
                                controller: dailyVerseController,
                                decoration: InputDecoration(
                                  hintText: "Add a New Verse",
                                  focusColor: currentTheme.dividerColor,
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  hoverColor: currentTheme.dividerColor,
                                ),
                                maxLines: null,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                width: MediaQuery.of(context).size.width,
                                text: "UPLOAD",
                                currentTheme: currentTheme,
                                onpressed: () {
                                  if (dailyVerseController.text.isNotEmpty) {
                                    ref
                                        .read(dailyVerseProvider.notifier)
                                        .uploadDailyVerseToFirebase(
                                          desc:
                                              dailyVerseController.text.trim(),
                                          docId: user.uid,
                                        );

                                    dailyVerseController.text = "";
                                    setState(() {});
                                  } else {
                                    showSnackBar(context,
                                        "Enter Verse Description", ref);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 100,
                                child: ref.watch(getDocumentsProvider).when(
                                      data: (data) {
                                        return data.isEmpty
                                            ? Text(
                                                "There are no Verse Added yet.",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              )
                                            : Center(
                                                child: ListView.builder(
                                                  itemCount: data.length,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, i) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Today's Verse : ",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          data[i]!
                                                              .desc
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                      },
                                      error: (err, trace) {
                                        return Center(
                                          child: Text(err.toString()),
                                        );
                                      },
                                      loading: () => const LoadingPage(),
                                    ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfleEditButtons extends StatelessWidget {
  final String text;
  final IconData trailingIcon;
  final IconData leadingIcon;
  final VoidCallback onPressed;
  final ThemeData currentTheme;
  const ProfleEditButtons({
    super.key,
    required this.currentTheme,
    required this.onPressed,
    required this.text,
    required this.trailingIcon,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onPressed,
        child: ListTile(
          tileColor: currentTheme.cardColor.withOpacity(0.1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide.none,
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          leading: Icon(
            leadingIcon,
          ),
          trailing: Icon(
            trailingIcon,
            size: 18,
          ),
        ),
      ),
    );
  }
}
