part of 'noticias_api_bloc.dart';

abstract class NoticiasApiState extends Equatable {
  const NoticiasApiState();

  @override
  List<Object> get props => [];
}

class NoticiasApiInitial extends NoticiasApiState {}

class LoadingState extends NoticiasApiState {}

class LoadedNoticiasState extends NoticiasApiState {
  final List<Noticia> noticiasList;

  LoadedNoticiasState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class LoadedSavedNoticiasState extends NoticiasApiState {
  final List<Noticia> noticiasList;

  LoadedSavedNoticiasState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class SavedNoticiaSuccesState extends NoticiasApiState {}

class ErrorMessageState extends NoticiasApiState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
