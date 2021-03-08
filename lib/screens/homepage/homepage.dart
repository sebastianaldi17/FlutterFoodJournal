import 'package:flutter/material.dart';

import 'foodrows.dart';

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Journal")
      ),
      body: Center(
        child: FoodRows(),
      ),
    );
  }
  
}
