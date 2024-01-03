part of 'task_list_bloc.dart';

@immutable
sealed class TaskListEvent {}

class TasklistSearch extends TaskListEvent {
  final String SearchTerm;

  TasklistSearch(this.SearchTerm);
}

class TasklistStarted extends TaskListEvent {}

class TaslistDeleteAll extends TaskListEvent {}
