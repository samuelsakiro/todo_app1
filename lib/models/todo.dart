import 'package:hive/hive.dart';

class ToDo {
  final String title;
  final bool isDone;

  ToDo({
    required this.title,
    this.isDone = false,
  });
}

class ToDoAdapter extends TypeAdapter<ToDo> {
  @override
  final int typeId = 0; // Unique ID for this adapter

  @override
  ToDo read(BinaryReader reader) {
    return ToDo(
      title: reader.readString(),
      isDone: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, ToDo obj) {
    writer.writeString(obj.title);
    writer.writeBool(obj.isDone);
  }
}
