import 'package:flutter/material.dart';
import 'package:flutter_example/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<ToDo> todosList = [
  ToDo(id: 1, description: 'タスク１', isCompleted: false),
  ToDo(id: 2, description: 'タスク１', isCompleted: false),
  ToDo(id: 3, description: 'タスク１', isCompleted: false)
];

class TodosNotifier extends StateNotifier<List<ToDo>> {
  TodosNotifier() : super(todosList);

  void addTodo(ToDo newTodo) {
    List<ToDo> newState = [];

    for (final todo in state) {
      newState.add(todo);
    }
    newState.add(newTodo);
    state = newState;
  }

  void toggle(int id) {
    List<ToDo> newState = [];
    for (final todo in state) {
      if (todo.id == id) {
        newState.add(todo.copywith(isCompleted: !todo.isCompleted));
      } else {
        newState.add(todo);
      }
      state = newState;
    }
  }
}
