import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_login/models/new.dart';
import 'package:share/share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ItemNoticia extends StatelessWidget {
  final New noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// TODO: Cambiar image.network por Extended Image con place holder en caso de error o mientras descarga la imagen
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
                  child: Image.network(
                    noticia.urlToImage ??
                        "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png",
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
                        Text(
                          "${noticia.title}",
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${noticia.publishedAt}",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                            fontSize: 12,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                child: Icon(
                                  Icons.share,
                                  size: 20,
                                ),
                                onTap: () {
                                  shareImage(noticia);
                                }),
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

  void shareImage(New noticia) async {
    String urlImage = noticia.urlToImage ??
        "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png";
    final response = await get(Uri.parse(urlImage));
    String extension = urlImage.split(".").last;
    final bytes = response.bodyBytes;

    final Directory temp = await getTemporaryDirectory();
    final File imageFile = File('${temp.path}/tempImage');
    imageFile.writeAsBytesSync(response.bodyBytes);

    Share.shareFiles(
      ['${temp.path}/tempImage.$extension'],
      text:
          'Checa está noticia ${noticia.title ?? "Noticia"} - ${noticia.description ?? "Sin descripcion"}" \n ${noticia.url ?? ""}',
    );
  }
}
