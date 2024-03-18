import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/features/home/screens/add_praise_screen_2.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/features/home/screens/update_praise_screen.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SavedPraiseScreen extends ConsumerStatefulWidget {
  const SavedPraiseScreen({super.key});

  @override
  ConsumerState<SavedPraiseScreen> createState() => _SavedPraiseScreen();
}

class _SavedPraiseScreen extends ConsumerState<SavedPraiseScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Prises",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
      body: ref.watch(getPraiseFromFirebaseProvider).when(
        data: (data) {
          return data.isEmpty
              ? const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("There are no Praises"),
                      SizedBox(height: 10),
                      Text("Add some praises to view"),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final praise = data[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => UpdatePraiseScreen(
                                  praiseModel: praise,
                                ),
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: currentTheme.cardColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          praise.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          "Target - ${praise.amount.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: currentTheme.primaryColor
                                                    .withOpacity(0.5),
                                              ),
                                        ),
                                        Text(
                                          "For ${praise.relation}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: currentTheme.primaryColor
                                                    .withOpacity(0.5),
                                              ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat.yMMMMd()
                                                  .format(praise.dateCreated),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: currentTheme
                                                        .primaryColor
                                                        .withOpacity(0.5),
                                                  ),
                                            ),
                                            Text(
                                              " - ${DateFormat.Hm().format(praise.dateCreated)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: currentTheme
                                                        .primaryColor
                                                        .withOpacity(0.5),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: currentTheme.splashColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              praise.num.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showAlertDialog(
                                              context: context,
                                              title:
                                                  "Are you sure want to delect",
                                              onTap1: () {
                                                Navigator.of(context).pop();
                                              },
                                              button1Text: "No",
                                              button2Text: "Yes",
                                              textColor:
                                                  currentTheme.primaryColor,
                                              onTap2: () {
                                                ref
                                                    .read(
                                                        praiseControllerProvider
                                                            .notifier)
                                                    .delectPraise(praise.id);
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          icon:
                                              const Icon(CupertinoIcons.delete),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                );
        },
        error: (error, st) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return const Loader();
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnnn",
        backgroundColor: Pallete.greenColor,
        foregroundColor: currentTheme.scaffoldBackgroundColor,
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const AddPraiseScreen2(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
        ),
      ),
    );
  }
}
