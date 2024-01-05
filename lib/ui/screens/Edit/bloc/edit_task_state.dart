part of 'edit_task_bloc.dart';

@immutable
sealed class EditTaskState {}

final class EditTaskInitial extends EditTaskState {}

final class EditTaskSucess extends EditTaskState {
  final TaskEntity taskEntity;

  EditTaskSucess(this.taskEntity);
}

final class NewTaskSucess extends EditTaskState {
  final TaskEntity taskEntity;
  NewTaskSucess(this.taskEntity);
}

final class EditTaskError extends EditTaskState {
  final String message;

  EditTaskError(this.message);
}
