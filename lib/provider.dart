import 'package:flutter/cupertino.dart';
import 'package:flutter_example/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<ToDo> todosList = [
  ToDo(id: 0, description: 'task1', isCompleted: false),
  ToDo(id: 1, description: 'task2', isCompleted: false),
  ToDo(id: 2, description: 'task3', isCompleted: false),
  ToDo(id: 3, description: 'task4', isCompleted: false),
  ToDo(id: 4, description: 'task5', isCompleted: false),
];

class TodosNotifier extends StateNotifier<List<ToDo>> {
  TodosNotifier() : super(todosList);

  void addTodounder(ToDo newTodo) {
    List<ToDo> newState = [];

    for (final todo in state) {
      newState.add(todo);
    }
    newState.add(newTodo);
    state = newState;
  }

  void addTodotop(ToDo newTodo) {
    List<ToDo> newState = [];

    newState.add(newTodo);

    for (final todo in state) {
      newState.add(todo);
    }

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

  void updateTaskDescription(int id, String newDescription) {
    List<ToDo> newState = [];

    for (final todo in state) {
      if (todo.id == id) {
        ToDo updatedTodo = todo.copywith(description: newDescription);
        newState.add(updatedTodo);
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

  void updateTodoDescription(int id, String newDescription) {}
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
