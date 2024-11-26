import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui'; // For glass effect
import '../models/todo.dart';

class HomeScreen extends StatelessWidget {
  final Box<ToDo> todoBox = Hive.box<ToDo>('todoBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.6),
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      backgroundColor: Colors.white, // Set the background to white
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<ToDo> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet! Tap the "+" button to get started.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final todo = box.getAt(index);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.2),
                            ),
                          ),
                          child: ListTile(
                            leading: FaIcon(
                              todo?.isDone ?? false
                                  ? FontAwesomeIcons.checkCircle
                                  : FontAwesomeIcons.circle,
                              color: todo?.isDone ?? false
                                  ? Colors.greenAccent
                                  : Colors.deepPurpleAccent,
                              size: 28,
                            ),
                            title: Text(
                              todo?.title ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                decoration: (todo?.isDone ?? false)
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.trashAlt,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                todoBox.deleteAt(index);
                              },
                            ),
                            onTap: () {
                              if (todo != null) {
                                todoBox.putAt(
                                  index,
                                  ToDo(title: todo.title, isDone: !(todo.isDone)),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Task title',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      todoBox.add(ToDo(title: controller.text));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
