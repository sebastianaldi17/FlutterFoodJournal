import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_journal/screens/homepage/homepage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../food.dart';

class NewFood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  String category = 'Food';
  String name;
  DateTime datetime;

  void showAlertDialog(BuildContext context, String title, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () { 
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create new food entry"),
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            child: Icon(
              Icons.arrow_back
            )
          ),
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
                  if(["", null, false, 0].contains(category)) {
                    showAlertDialog(context, "Error", "Please select a category!");
                    return;
                  }
                  
                  if(["", null, false, 0].contains(name)) {
                    showAlertDialog(context, "Error", "Please enter a food name!");
                    return;
                  }

                  if(datetime == null) {
                    showAlertDialog(context, "Error", "Please enter a date and time!");
                    return;
                  }

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
