import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/home/noticias_ext_api/bloc/noticias_api_bloc.dart';
import 'package:noticias/home/noticias_firebase/bloc/my_noticias_bloc.dart'
    as my_noticias_bloc;
import 'package:noticias/models/noticia.dart';

import 'item_noticia.dart';

class Noticias extends StatefulWidget {
  const Noticias({Key key}) : super(key: key);

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  NoticiasApiBloc _noticias_api_bloc;
  String _currentQuery = "";
  final _cFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _noticias_api_bloc = NoticiasApiBloc();
        _noticias_api_bloc
          ..add(RequestNoticiasApiEvent(query: this._currentQuery));
        return _noticias_api_bloc;
      },
      child: Container(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: "Search news!",
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue[600],
                ),
                contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
              ),
              onSubmitted: (String query) {
                _noticias_api_bloc.add(RequestNoticiasApiEvent(query: query));
              },
            ),
          ),
          BlocConsumer<NoticiasApiBloc, NoticiasApiState>(
              listener: (context, state) {
            if (state is ErrorMessageState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.errorMsg),
                  ),
                );
            } else if (state is LoadedSavedNoticiasState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("Mostrando noticias guardadas localmente"),
                  ),
                );
            }
          }, builder: (context, state) {
            if (state is LoadedNoticiasState) {
              return NoticiasEncontradas(
                noticiasList: state.noticiasList,
                function: _saveNoticias,
              );
            } else if (state is LoadedSavedNoticiasState) {
              return NoticiasEncontradas(
                noticiasList: state.noticiasList,
                function: _saveNoticias,
              );
            } else if (state is ErrorMessageState) {
              return Center(
                child: Text("Algo salio mal", style: TextStyle(fontSize: 32)),
              );
            }
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }),
        ],
      )),
    );
  }

  Future<void> _saveNoticias(
    Noticia noticia,
  ) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi)
        throw Exception("Offline");
      await _cFirestore.collection("noticias").add(noticia.toJson());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Noticia guardada"),
          ),
        );
      //Después de guardar la noticia en Firebase, las noticias de Firebase en Mis noticias se deben actualizar automáticamente.
      BlocProvider.of<my_noticias_bloc.MyNoticiasBloc>(context)
          .add(my_noticias_bloc.RequestAllNoticiasEvent());
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Error: $e"),
          ),
        );
    }
  }
}

class NoticiasEncontradas extends StatelessWidget {
  final List<Noticia> noticiasList;
  final Function function;
  const NoticiasEncontradas({
    @required this.noticiasList,
    Key key,
    @required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: noticiasList.length == 0
          ? Center(
              child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Text(
                "No se encontraron noticias guardadas localmente",
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
            ))
          : ListView.builder(
              itemCount: noticiasList.length,
              itemBuilder: (context, index) {
                return ItemNoticia(noticia: noticiasList[index]);
              },
            ),
    );
  }
}
