import 'package:hive/hive.dart';

part 'food.g.dart';

@HiveType(typeId: 0)
class Food {
  @HiveField(0)
  String category; // Meal / Snack / Drink / ...
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime foodDate;
  @HiveField(3)
  String id;

  Food(this.id, this.name, this.category, this.foodDate);
}
