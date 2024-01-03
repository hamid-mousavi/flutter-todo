import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:todo/data/repo/Repository.dart';
import 'package:todo/task.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TasklistStarted || event is TasklistSearch) {
        final String serchTerm;

        emit(TaskListLoading());
        await Future.delayed(Duration(seconds: 1));
        if (event is TasklistSearch) {
          serchTerm = event.SearchTerm;
        } else {
          serchTerm = '';
        }
        try {
          // throw Exception();
          final items = await repository.getAll(searchKey: serchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSucccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError(e.toString()));
        }
      } else if (event is TaslistDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
