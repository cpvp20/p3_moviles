import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:noticias/models/noticia.dart';

part 'my_noticias_event.dart';
part 'my_noticias_state.dart';

class MyNoticiasBloc extends Bloc<MyNoticiasEvent, MyNoticiasState> {
  final _cFirestore = FirebaseFirestore.instance;

  MyNoticiasBloc() : super(MyNoticiasInitial());

  @override
  Stream<MyNoticiasState> mapEventToState(
    MyNoticiasEvent event,
  ) async* {
    if (event is RequestAllNoticiasEvent) {
      yield LoadingState();
      yield LoadedNoticiasState(noticiasList: await _getNoticias() ?? []);
    }
  }

  // recurpera la lista de docs en firestore
  // map a objet de dart
  // cada elemento agregarlo a una lista.
  Future<List<Noticia>> _getNoticias() async {
    try {
      var noticias = await _cFirestore.collection("noticias").get();
      print("obteniendo noticias de la firebase DB");
      return noticias.docs
          .map(
            (element) => Noticia(
              author: element["author"],
              title: element["title"],
              urlToImage: element["urlToImage"],
              description: element["description"],
            ),
          )
          .toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
