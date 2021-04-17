import 'dart:convert';
import 'dart:io';

import 'package:noticias/models/noticia.dart';
import 'package:noticias/utils/secrets.dart';
import 'package:http/http.dart';

class NoticiasRepository {
  List<Noticia> _noticiasList;

  static final NoticiasRepository _noticiasRepository =
      NoticiasRepository._internal();
  factory NoticiasRepository() {
    return _noticiasRepository;
  }

  NoticiasRepository._internal();
  Future<List<Noticia>> getAvailableNoticias(String query) async {
    var queryParams = {
      "apiKey": apiKey,
    };

    if (query == "") {
      queryParams["category"] = "sports";
      queryParams["country"] = "mx";
    } else {
      queryParams["q"] = query;
    }

    final _uri = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/top-headlines',
      queryParameters: queryParams,
    );
    try {
      final response = await get(_uri);
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> data = jsonDecode(response.body)["articles"];
        _noticiasList =
            ((data).map((element) => Noticia.fromJson(element))).toList();
        return _noticiasList;
      }
      return [];
    } catch (e) {
      //arroje un error
      throw "Ha ocurrido un error: $e";
    }
  }
}
