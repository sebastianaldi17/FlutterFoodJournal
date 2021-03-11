import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_journal/screens/homepage/homepage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../food.dart';

class EditFood extends StatefulWidget {
  final int foodIndex;

  EditFood({Key key, @required this.foodIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditFoodState(foodIndex);
}

class _EditFoodState extends State<EditFood> {
  int foodIndex;
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

  _EditFoodState(int foodIndex) {
    this.foodIndex = foodIndex;

    final foodBox = Hive.box('food');
    final food = foodBox.get(foodIndex) as Food;

    category = food.category;
    datetime = food.foodDate;
    name = food.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit existing food entry"),
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: Icon(Icons.arrow_back)),
          actions: [
            GestureDetector(
              onTap: () {
                try {
                  final foodBox = Hive.box('food');
                  foodBox.deleteAt(foodIndex);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                } catch (e) {
                  // Alert user (say something went wrong)
                  print(e);
                  showAlertDialog(context, "Error", "An error occured while trying to delete, please try again or reopen the app.");
                }
              },
              child: Icon(Icons.delete_forever),
            ),
          ],
        ),
        body: Form(
            child: Column(
          children: [
            TextFormField(
              initialValue: name,
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
              initialValue: datetime,
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
                  if (["", null, false, 0].contains(category)) {
                    showAlertDialog(
                        context, "Error", "Please select a category!");
                    return;
                  }

                  if (["", null, false, 0].contains(name)) {
                    showAlertDialog(
                        context, "Error", "Please enter a food name!");
                    return;
                  }

                  if (datetime == null) {
                    showAlertDialog(
                        context, "Error", "Please enter a date and time!");
                    return;
                  }

                  try {
                    final foodBox = Hive.box('food');
                    foodBox.putAt(
                        foodIndex, new Food(name, category, datetime));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  } catch (e) {
                    // Alert user (say something went wrong)
                    print(e);
                    showAlertDialog(context, "Error", "An error occured while trying to save, please try again or reopen the app.");
                  }
                },
                child: Text('Save changes'),
              ),
            ),
          ],
        )));
  }
}
