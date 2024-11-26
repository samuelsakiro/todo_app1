import 'package:hive/hive.dart';
import '../models/todo.dart';

class HiveBoxes {
  static Box<ToDo> getToDoBox() => Hive.box<ToDo>('todoBox');
}
