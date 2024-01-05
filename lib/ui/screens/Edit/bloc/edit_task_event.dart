part of 'edit_task_bloc.dart';

@immutable
sealed class EditTaskEvent {}

class SaveChangeBtn extends EditTaskEvent {
  final TaskEntity taskEntity;
  SaveChangeBtn(this.taskEntity);
}

class OnPeriorityChange extends EditTaskEvent {}
