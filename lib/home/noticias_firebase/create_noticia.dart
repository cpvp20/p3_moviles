import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/home/noticias_firebase/bloc/my_noticias_bloc.dart'
    as myNoticiasBloc;
import 'bloc/create_noticia_bloc.dart';

class CreateNoticia extends StatefulWidget {
  CreateNoticia({Key key}) : super(key: key);

  @override
  _CreateNoticiaState createState() => _CreateNoticiaState();
}

class _CreateNoticiaState extends State<CreateNoticia> {
  File slectedImage;
  CreateNoticiaBloc
      _bloc; //se le agreguan los eventos de seleccionar foto y guardar noticia
  var autorTc = TextEditingController();
  var tituloTc = TextEditingController();
  var descrTc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = CreateNoticiaBloc();
        return _bloc;
      },
      child: BlocConsumer<CreateNoticiaBloc, CreateNoticiaState>(
        listener: (context, state) {
          if (state is PickedImageState) {
            slectedImage = state.image;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Imagen seleccionada"),
                ),
              );
          } else if (state is SavedNoticiaState) {
            //Después de guardar la noticia en Firebase, las noticias
            //de en la pantalla de Mis noticias se deben actualizar automáticamente.
            BlocProvider.of<myNoticiasBloc.MyNoticiasBloc>(context)
                .add(myNoticiasBloc.RequestAllNoticiasEvent());
            autorTc.clear();
            tituloTc.clear();
            descrTc.clear();
            slectedImage = null;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Noticia guardada exitosamente"),
                ),
              );
          } else if (state is ErrorMessageState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Error: ${state.errorMsg}"),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _createForm();
        },
      ),
    );
  }

  Widget _createForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            slectedImage != null
                ? Image.file(
                    slectedImage,
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    child: Placeholder(),
                  ),
            SizedBox(height: 16),
            TextField(
              controller: autorTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Autor',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tituloTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Titulo',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descrTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripcion',
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              child: Text("Imagen"),
              onPressed: () {
                _bloc.add(PickImageEvent());
              },
            ),
            MaterialButton(
              child: Text("Guardar"),
              onPressed: () {
                _bloc.add(
                  SaveNoticiaEvent(
                    noticia: Noticia(
                      author: autorTc.text,
                      title: tituloTc.text,
                      description: descrTc.text,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
