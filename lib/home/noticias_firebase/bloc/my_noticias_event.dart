part of 'my_noticias_bloc.dart';

abstract class MyNoticiasEvent extends Equatable {
  const MyNoticiasEvent();

  @override
  List<Object> get props => [];
}

class RequestAllNoticiasEvent extends MyNoticiasEvent {
  @override
  List<Object> get props => [];
}
