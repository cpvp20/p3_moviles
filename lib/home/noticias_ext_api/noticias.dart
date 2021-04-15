import 'package:flutter/material.dart';
import 'package:google_login/utils/news_repository.dart';

import 'item_noticia.dart';

class Noticias extends StatefulWidget {
  const Noticias({Key key}) : super(key: key);

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  // final _textController = TextEditingController();
  String _currentQuery = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: NewsRepository().getAvailableNoticias(_currentQuery),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Algo salio mal", style: TextStyle(fontSize: 32)),
            );
          }
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
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
                      setState(() {
                        _currentQuery = query;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: snapshot.data.length == 0
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: Text(
                            "No se encontraron noticias",
                            style: TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        ))
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ItemNoticia(
                              noticia: snapshot.data[index],
                            );
                          },
                        ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
