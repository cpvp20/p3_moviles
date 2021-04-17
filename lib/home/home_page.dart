import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/bloc/auth_bloc.dart';
import 'package:noticias/home/noticias_firebase/my_noticias.dart';
import 'noticias_ext_api/noticias.dart';
import 'package:noticias/home/noticias_firebase/create_noticia.dart';

import 'noticias_firebase/bloc/my_noticias_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final _titulosList = [
    "Noticias",
    "Mis noticias",
    "Crear Noticia",
  ];
  final _pagesList = [
    Noticias(),
    MyNoticias(),
    CreateNoticia(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyNoticiasBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("${_titulosList[_currentPageIndex]}"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  SignOutAuthenticationEvent(),
                );
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentPageIndex,
          children: _pagesList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "${_titulosList[0]}",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "${_titulosList[1]}",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: "${_titulosList[2]}",
            ),
          ],
        ),
      ),
    );
  }
}
