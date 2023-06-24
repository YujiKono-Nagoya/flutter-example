import 'package:flutter/material.dart';
import 'package:flutter_example/example.dart';
import 'package:flutter_example/model.dart';
import 'package:flutter_example/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ToDo> todoList = ref.watch(todosProvider);
    final bool isEditMode = ref.watch(editModeProvider);
    final items = ref.watch(itemsProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Todoリスト',
          ),
          actions: [
            IconButton(
                onPressed: () {
                  ref.read(editModeProvider.notifier).toggleEditMode();
                },
                icon: isEditMode ? Icon(Icons.check) : Icon(Icons.edit))
          ],
        ),
        body: ReorderableListView.builder(
          header: isEditMode
              ? GestureDetector(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          String description = '';
                          return AlertDialog(
                              title: const Text('タスクを追加'),
                              content: TextField(onChanged: (value) {
                                description = value;
                              }),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('cancel')),
                                TextButton(
                                    onPressed: () {
                                      ref.read(todosProvider.notifier).addTodo(
                                          ToDo(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              description: description,
                                              isCompleted: false));
                                    },
                                    child: Text('OK')),
                              ]);
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add), Text('タスクを追加する')],
                  ))
              : null,
          itemBuilder: (context, index) {
            ToDo item = todoList[index];
            return Card(
              key: ValueKey(item),
              child: GestureDetector(
                onTap: () {
                  ref.read(todosProvider.notifier).toggle(item.id);
                },
                child: ListTile(
                  title: Text(item.description),
                  trailing: isEditMode
                      ? IconButton(
                          onPressed: () {
                            ref
                                .read(todosProvider.notifier)
                                .removeTodoAtIndex(index);
                          },
                          icon: Icon(Icons.delete),
                        )
                      : item.isCompleted
                          ? Icon(Icons.check)
                          : null,
                ),
              ),
            );
          },
          itemCount: todoList.length,
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final model = todoList.removeAt(oldIndex);
            todoList.insert(newIndex, model);
          },
          footer: isEditMode
              ? GestureDetector(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          String description = '';
                          return AlertDialog(
                              title: const Text('タスクを追加'),
                              content: TextField(onChanged: (value) {
                                description = value;
                              }),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('cancel')),
                                TextButton(
                                    onPressed: () {
                                      ref.read(todosProvider.notifier).addTodo(
                                          ToDo(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              description: description,
                                              isCompleted: false));
                                    },
                                    child: Text('OK')),
                              ]);
                        });
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.add), Text('タスクを追加する')]),
                )
              : null,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.next_plan_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Example()),
              );
            }));
  }
}
