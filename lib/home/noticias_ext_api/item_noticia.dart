import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noticias/home/noticias_ext_api/noticia_details.dart';
import 'package:noticias/models/noticia.dart';
import 'package:share/share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ItemNoticia extends StatelessWidget {
  final Noticia noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child:
                      (noticia.urlToImage == null || noticia.urlToImage == "")
                          ? Image.asset(
                              'assets/placeholder.png',
                              fit: BoxFit.fitHeight,
                            )
                          : Image.network(
                              noticia.urlToImage,
                              fit: BoxFit.fitHeight,
                            ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoticiaDetails(noticia: noticia),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${noticia.title}",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "${noticia.description ?? "Descripcion no disponible"}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "${noticia.author ?? "Autor no disponible"}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.share,
                                size: 30,
                              ),
                              onPressed: () {
                                share(noticia, context);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//funcionalidad de compartir noticias por Whatsapp o instagram o facebook o cualquier app similar cómo email, etc.
  void share(Noticia noticia, context) async {
    try {
      String urlImage = noticia.urlToImage ??
          "https://artsmidnorthcoast.com/wp-content/uploads/2014/05/no-image-available-icon-6.png";
      final response = await get(Uri.parse(urlImage));
      String extension = urlImage.split(".").last.split('?').first;

      final Directory temp = await getTemporaryDirectory();
      final File imageFile = File('${temp.path}/${noticia.title}.$extension');
      imageFile.writeAsBytesSync(response.bodyBytes);

      Share.shareFiles(
        ['${temp.path}/${noticia.title}.$extension'],
        text:
            '${noticia.title} - ${noticia.description ?? "Sin descripcion"}" \n ${noticia.url ?? ""}',
        subject: 'Checate esta noticia! ',
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Error: No se puede compartir por el momento"),
          ),
        );
    }
  }
}
