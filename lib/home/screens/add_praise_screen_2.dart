import 'package:digital_counter/common/utils.dart';
import 'package:digital_counter/home/screens/add_praise_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPraiseScreen2 extends StatefulWidget {
  const AddPraiseScreen2({super.key});

  @override
  State<AddPraiseScreen2> createState() => _AddPraiseScreen2State();
}

class _AddPraiseScreen2State extends State<AddPraiseScreen2> {
  String dropdownvalue = "Father";
  final amountController = TextEditingController();
  var items = [
    'Father',
    'Mother',
    'Sister',
    'Brother',
    'Friends',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "To who do you want to send praise",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.arrow_downward),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(items),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.40,
                child: TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    hintText: "Enter Amount",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.trim().isNotEmpty) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => AddPraiseScreen(
                      relation: dropdownvalue,
                      amount: amountController.text.trim(),
                    ),
                  ),
                );
              } else {
                showSnackBar(context, "Please enter valid amount");
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text("CONTINUE"),
          ),
        ],
      ),
    );
  }
}
