import 'package:flutter/cupertino.dart';
import 'package:flutter_example/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<ToDo> todosList = [];

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
    }
    state = newState;
  }

  void removeTodoAtIndex(int index) {
    List<ToDo> updatedList = [];

    for (final todo in state) {
      updatedList.add(todo);
    }
    updatedList.removeAt(index);
    state = updatedList;
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<ToDo>>((ref) {
  return TodosNotifier();
});

final completedTodosProvider = Provider((ref) {
  final todos = ref.watch(todosProvider);

  return todos.where((todo) => todo.isCompleted);
});

final uncompletedTodosProvider = Provider((ref) {
  final todos = ref.watch(todosProvider);

  return todos.where((todo) => !todo.isCompleted);
});

class EditModeNotifier extends StateNotifier<bool> {
  EditModeNotifier() : super(false);

  void toggleEditMode() {
    state = !state;
  }
}

final editModeProvider = StateNotifierProvider<EditModeNotifier, bool>((ref) {
  return EditModeNotifier();
});

class ItemNotifier extends StateNotifier<List<int>> {
  ItemNotifier() : super([]);

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
  }
}

final itemsProvider = StateNotifierProvider<ItemNotifier, List<int>>((ref) {
  return ItemNotifier();
});
