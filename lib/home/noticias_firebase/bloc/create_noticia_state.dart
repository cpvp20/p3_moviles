part of 'create_noticia_bloc.dart';

abstract class CreateNoticiaState extends Equatable {
  const CreateNoticiaState();

  @override
  List<Object> get props => [];
}

class LoadingState extends CreateNoticiaState {}

class CreateNoticiaInitial extends CreateNoticiaState {}

class PickedImageState extends CreateNoticiaInitial {
  final File image;

  PickedImageState({@required this.image});
  @override
  List<Object> get props => [image];
}

class SavedNoticiaState extends CreateNoticiaInitial {
  List<Object> get props => [];
}

class ErrorMessageState extends CreateNoticiaInitial {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
