import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo/data/repo/Repository.dart';
import 'package:todo/task.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final Repository reop;
  EditTaskBloc(this.reop) : super(EditTaskInitial()) {
    on<EditTaskEvent>((event, emit) {
      if (event is SaveChangeBtn) {
        try {
          reop.updateOrCreate(event.taskEntity);
          emit(NewTaskSucess(event.taskEntity));
        } catch (e) {
          emit(EditTaskError('message'));
        }
      }
    });
  }
}
