import 'package:flutter/material.dart';
import 'package:flutter_example/example.dart';
import 'package:flutter_example/model.dart';
import 'package:flutter_example/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> itemList = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text('Todoリスト'),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  tapped = !tapped;
                });
              },
              child: Icon(tapped ? Icons.edit : Icons.check),
            ),
          ],
        ),
        body: ReorderableListView.builder(
          header: tapped
              ? GestureDetector(
                  onTap: () {
                    setState(() {
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
                                      onPressed: () {}, child: Text('OK')),
                                ]);
                          });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add), Text('タスクを追加する')],
                  ))
              : null,
          itemBuilder: (context, index) {
            String item = itemList[index];
            return Card(
              key: ValueKey(item),
              child: ListTile(
                title: Text(itemList[index]),
                trailing: tapped
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            itemList.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.delete),
                      )
                    : null,
              ),
            );
          },
          itemCount: itemList.length,
          onReorder: (oldIndex, newIndex) => setState(() {
            try {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = itemList.removeAt(oldIndex);
              itemList.insert(newIndex, item);
            } catch (e) {
              print('$e');
            }
          }),
          footer: tapped
              ? GestureDetector(
                  onTap: () {
                    setState(() {
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
                                        setState(() {});
                                      },
                                      child: Text('OK')),
                                ]);
                          });
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
