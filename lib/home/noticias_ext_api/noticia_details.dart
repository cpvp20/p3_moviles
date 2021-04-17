import 'package:flutter/material.dart';
import 'package:noticias/models/noticia.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiaDetails extends StatelessWidget {
  final Noticia noticia;
  const NoticiaDetails({Key key, @required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de noticia"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 5, right: 15, left: 15),
              child: Text(
                noticia.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            (noticia.urlToImage == null || noticia.urlToImage == "")
                ? Image.network(
                    "https://artsmidnorthcoast.com/wp-content/uploads/2014/05/no-image-available-icon-6.png",
                    fit: BoxFit.fitWidth,
                  )
                : Image.network(
                    noticia.urlToImage,
                    fit: BoxFit.fitWidth,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: Text(
                "${noticia.author ?? "Autor no disponible"}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "${noticia.description ?? "Descripcion no disponible"}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text(
                "${noticia.content ?? ""}",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  if (noticia.url != null) {
                    launch(noticia.url,
                        enableJavaScript: true,
                        forceWebView: true,
                        enableDomStorage: true);
                  } else {
                    launch("https://google.com",
                        enableJavaScript: true,
                        forceWebView: true,
                        enableDomStorage: true);
                  }
                },
                child: Text(
                  "Ver noticia completa",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
