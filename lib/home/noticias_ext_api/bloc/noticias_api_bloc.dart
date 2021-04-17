import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/utils/noticias_repository.dart';
import 'package:hive/hive.dart';
import 'package:connectivity/connectivity.dart';

part 'noticias_api_event.dart';
part 'noticias_api_state.dart';

class NoticiasApiBloc extends Bloc<NoticiasApiEvent, NoticiasApiState> {
  NoticiasApiBloc() : super(NoticiasApiInitial());

  Box _noticiasBox = Hive.box("Noticias");

  @override
  Stream<NoticiasApiState> mapEventToState(
    NoticiasApiEvent event,
  ) async* {
    if (event is RequestNoticiasApiEvent) {
      try {
        yield LoadingState();
        //checar conexion
        var connectivityResult = await (Connectivity().checkConnectivity());

        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          //si el usuario abre la app con acceso a internet puede ver las noticias de la API
          List<Noticia> noticiasList =
              await NoticiasRepository().getAvailableNoticias(event.query);
          //ademas la app internamente debe guardar la lista de noticias en el almacenamiento local
          List<Noticia> hiveNoticiasList = noticiasList
              .map((Noticia e) => e.copyWith(urlToImage: ""))
              .toList();
          await _noticiasBox.put('noticias', hiveNoticiasList);
          print("Noticias guardadas localmente");
          yield LoadedNoticiasState(noticiasList: noticiasList);
        } else {
          //si el usuario abre la app sin acceso a internet puede ver las noticias
          //guaradads localmente en Hive
          List<Noticia> noticiasList = List<Noticia>.from(
            _noticiasBox.get("noticias", defaultValue: []),
          );
          yield LoadedSavedNoticiasState(noticiasList: noticiasList);
        }
      } catch (e) {
        yield ErrorMessageState(
            errorMsg: "Error al obtener lista de noticias: $e");
      }
    }
  }
}
