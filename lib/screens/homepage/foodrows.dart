import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_journal/screens/foodedit/editfood.dart';
import 'package:food_journal/screens/foodentry/newfood.dart';
import 'package:hive/hive.dart';

import '../../food.dart';

class FoodRows extends StatefulWidget {
  @override
  _FoodRowsState createState() => _FoodRowsState();
}

class _FoodRowsState extends State<FoodRows> {
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _addFood() {
    // Navigate to newfood
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NewFood()));
  }

  Widget _buildEntries() {
    final foodBox = Hive.box('food');
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemBuilder: (context, i) {
        final food = foodBox.get(i) as Food;
        return Card(
          child: ListTile(
            title: Text(
              food.name + " - " + food.foodDate.toString(),
              style: _biggerFont,
            ),
            trailing: Icon(
              Icons.edit,
            ),
            onTap: () {
              // Navigate to editfood
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EditFood(foodIndex: i),
                ),
              );
            },
          ),
        );
      },
      itemCount: foodBox.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildEntries(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFood,
        tooltip: 'Add new food',
        child: Icon(Icons.add),
      ),
    );
  }
}
