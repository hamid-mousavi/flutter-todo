part of 'task_list_bloc.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

final class TaskListSucccess extends TaskListState {
  final List<TaskEntity> tasks;

  TaskListSucccess(this.tasks);
}

final class TaskListError extends TaskListState {
  final String message;

  TaskListError(this.message);
}

final class TaskListLoading extends TaskListState {}

final class TaskListEmpty extends TaskListState {}
