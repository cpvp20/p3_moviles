part of 'create_noticia_bloc.dart';

abstract class CreateNoticiaEvent extends Equatable {
  const CreateNoticiaEvent();

  @override
  List<Object> get props => [];
}

class SaveNoticiaEvent extends CreateNoticiaEvent {
  final Noticia noticia;

  SaveNoticiaEvent({@required this.noticia});
  @override
  List<Object> get props => [noticia];
}

class PickImageEvent extends CreateNoticiaEvent {
  @override
  List<Object> get props => [];
}
