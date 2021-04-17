import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/home/noticias_ext_api/item_noticia.dart';

import 'bloc/my_noticias_bloc.dart';

//esta es la pantalla que lee noticias de firebase

class MyNoticias extends StatefulWidget {
  MyNoticias({Key key}) : super(key: key);

  @override
  _MyNoticiasState createState() => _MyNoticiasState();
}

class _MyNoticiasState extends State<MyNoticias> {
  @override
  void initState() {
    BlocProvider.of<MyNoticiasBloc>(context).add(RequestAllNoticiasEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyNoticiasBloc, MyNoticiasState>(
      listener: (context, state) {
        if (state is ErrorMessageState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("${state.errorMsg}"),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is LoadedNoticiasState) {
          //Agregar Refresh indicator a pantalla de Mis noticias
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<MyNoticiasBloc>(context)
                  .add(RequestAllNoticiasEvent());
              return;
            },
            child: ListView.builder(
              itemCount: state.noticiasList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNoticia(noticia: state.noticiasList[index]);
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
