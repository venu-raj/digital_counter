// import 'package:digital_counter/features/daily_verse/daily_verse_controller.dart';
// import 'package:digital_counter/networking/controller/praise_controller.dart';
// import 'package:digital_counter/utils/common/custom_button.dart';
// import 'package:digital_counter/utils/common/loader.dart';
// import 'package:digital_counter/utils/common/utils.dart';
// import 'package:digital_counter/utils/theme/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DailyVerseScreen extends ConsumerStatefulWidget {
//   const DailyVerseScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _DailyVerseScreenState();
// }

// class _DailyVerseScreenState extends ConsumerState<DailyVerseScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final currentTheme = ref.watch(themeNotifierProvider);
//     final user = ref.watch(userProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Todays Verse",
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//       ),
//       body: ref.watch(getDocumentsProvider).when(
//             data: (data) {
//               return user!.isAdmin == false
//                   ? data.isEmpty
//                       ? Center(
//                           child: Text(
//                             "There are no Verse Added yet.",
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         )
//                       : Column(
//                           children: [
//                             const Spacer(),
//                             Expanded(
//                               child: ListView.builder(
//                                 itemCount: data.length,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemBuilder: (context, i) {
//                                   return Center(
//                                     child: Text(
//                                       data[i]!.desc.toString(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             const Spacer(),
//                           ],
//                         )
//                   : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Column(
//                         children: [
//                           TextField(
//                             controller: dailyVerseController,
//                             decoration: InputDecoration(
//                               hintText: "Add a New Verse",
//                               focusColor: currentTheme.dividerColor,
//                               border: const OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10),
//                                 ),
//                               ),
//                               hoverColor: currentTheme.dividerColor,
//                             ),
//                             maxLines: null,
//                             maxLength: 150,
//                             keyboardType: TextInputType.text,
//                           ),
//                           const SizedBox(height: 10),
//                           CustomButton(
//                             width: MediaQuery.of(context).size.width,
//                             text: "CONTINUE",
//                             currentTheme: currentTheme,
//                             onpressed: () {
//                               if (dailyVerseController.text.isNotEmpty) {
//                                 ref
//                                     .read(dailyVerseProvider.notifier)
//                                     .uploadDailyVerseToFirebase(
//                                       desc: dailyVerseController.text.trim(),
//                                       docId: user.uid,
//                                     );

//                                 dailyVerseController.text = "";
//                                 setState(() {});
//                               } else {
//                                 showSnackBar(
//                                     context, "Enter Verse Description", ref);
//                               }
//                             },
//                           ),
//                           const Spacer(flex: 1),
//                           const SizedBox(height: 5),
//                           data.isEmpty
//                               ? Center(
//                                   child: Text(
//                                     "There are no Verse Added yet.",
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 )
//                               : Expanded(
//                                   child: ListView.builder(
//                                     itemCount: data.length,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemBuilder: (context, i) {
//                                       return Center(
//                                         child: Text(
//                                           data[i]!.desc.toString(),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                           const Spacer(flex: 2),
//                         ],
//                       ),
//                     );
//             },
//             error: (err, trace) {
//               return Center(
//                 child: Text(err.toString()),
//               );
//             },
//             loading: () => const LoadingPage(),
//           ),
//       // body: SafeArea(
//       //   child: Padding(
//       //     padding: const EdgeInsets.symmetric(horizontal: 20),
//       //     child: Column(
//       //       children: [
//       //         Column(
//       //           children: [
//       //             TextField(
//       //               controller: dailyVerseController,
//       //               decoration: InputDecoration(
//       //                 hintText: "Add a New Verse",
//       //                 focusColor: currentTheme.dividerColor,
//       //                 border: const OutlineInputBorder(
//       //                   borderRadius: BorderRadius.all(
//       //                     Radius.circular(10),
//       //                   ),
//       //                 ),
//       //                 hoverColor: currentTheme.dividerColor,
//       //               ),
//       //               maxLines: 4,
//       //               keyboardType: TextInputType.text,
//       //             ),
//       //             CustomButton(
//       //               text: "CONTINUE",
//       //               currentTheme: currentTheme,
//       //               onpressed: () {
//       //                 ref
//       //                     .read(dailyVerseProvider.notifier)
//       //                     .uploadDailyVerseToFirebase(
//       //                       desc: dailyVerseController.text.trim(),
//       //                       docId: user!.uid,
//       //                     );

//       //                 dailyVerseController.text = "";
//       //               },
//       //             ),
//       //             ref.watch(getDocumentsProvider).when(
//       //                   data: (data) {
//       //                     return Text(data.desc);
//       //                   },
//       //                   error: (err, trace) {
//       //                     return Center(
//       //                       child: Text(err.toString()),
//       //                     );
//       //                   },
//       //                   loading: () => const LoadingPage(),
//       //                 ),
//       //           ],
//       //         )
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
