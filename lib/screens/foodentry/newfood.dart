import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_journal/screens/homepage/homepage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../food.dart';

// TODO: Create back button
// TODO: Input validation (not null)

class NewFood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  String category = 'Food';
  String name;
  DateTime datetime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create new food entry"),
        ),
        body: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Food name',
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            // Drop down list
            DropdownButton(
                value: category,
                items: ['Food', 'Snack', 'Drink']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    category = newValue;
                  });
                }),

            // Date picker
            DateTimeField(
              format: DateFormat("yyyy-MM-dd HH:mm"),
              onChanged: (value) {
                datetime = value;
              },
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate
                  print(category);
                  print(name);
                  print(datetime);

                  // Insert to box(db)
                  try {
                    final foodBox = Hive.box('food');
                    foodBox.add(new Food(name, category, datetime));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  } catch (e) {
                    // Alert user (say something went wrong)
                    print(e);
                  }
                },
                child: Text('Add new food'),
              ),
            ),
          ],
        )));
  }
}
