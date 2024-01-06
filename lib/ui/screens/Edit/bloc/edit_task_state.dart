part of 'edit_task_bloc.dart';

@immutable
sealed class EditTaskState {
  final TaskEntity task;

  EditTaskState(this.task);
}

final class EditTaskInitial extends EditTaskState {
  EditTaskInitial(super.task);
}

final class EditTaskSucess extends EditTaskState {
  EditTaskSucess(super.task);
}

final class NewTaskSucess extends EditTaskState {
  NewTaskSucess(super.task);
}

final class EditTaskError extends EditTaskState {
  EditTaskError(super.task);
}

final class PeriorityChanged extends EditTaskState {
  PeriorityChanged(super.task);
}
