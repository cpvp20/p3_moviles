part of 'noticias_api_bloc.dart';

abstract class NoticiasApiEvent extends Equatable {
  const NoticiasApiEvent();

  @override
  List<Object> get props => [];
}

class RequestNoticiasApiEvent extends NoticiasApiEvent {
  final String query;

  RequestNoticiasApiEvent({@required this.query});
  @override
  List<Object> get props => [query];
}
