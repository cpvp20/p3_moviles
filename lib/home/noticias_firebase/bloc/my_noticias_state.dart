part of 'my_noticias_bloc.dart';

abstract class MyNoticiasState extends Equatable {
  const MyNoticiasState();

  @override
  List<Object> get props => [];
}

class MyNoticiasInitial extends MyNoticiasState {}

class LoadingState extends MyNoticiasState {}

class LoadedNoticiasState extends MyNoticiasState {
  final List<Noticia> noticiasList;

  LoadedNoticiasState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class ErrorMessageState extends MyNoticiasState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
