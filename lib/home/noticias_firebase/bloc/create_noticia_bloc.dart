import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:noticias/models/noticia.dart';
import 'package:image_picker/image_picker.dart';

part 'create_noticia_event.dart';
part 'create_noticia_state.dart';

class CreateNoticiaBloc extends Bloc<CreateNoticiaEvent, CreateNoticiaState> {
  final _cFirestore = FirebaseFirestore.instance;
  File _selectedPicture;
  CreateNoticiaBloc() : super(CreateNoticiaInitial());

  @override
  Stream<CreateNoticiaState> mapEventToState(
    CreateNoticiaEvent event,
  ) async* {
    if (event is PickImageEvent) {
      yield LoadingState();
      _selectedPicture = await _getImage();
      yield PickedImageState(image: _selectedPicture);
    } else if (event is SaveNoticiaEvent) {
      // 1) subir archivo a bucket
      // 2) extraer url del archivo
      // 3) agregar url al elemento de firebase
      // 4) guardar elemento en firebase
      // 5) actualizar lista con RequestAllNoticiasEvent
      String imageUrl = await _uploadFile();
      if (imageUrl != null) {
        yield LoadingState();
        await _saveNoticias(event.noticia.copyWith(urlToImage: imageUrl));
        // yield LoadedNoticiasState(noticiasList: await _getNoticias() ?? []);
        yield SavedNoticiaState();
      } else {
        yield ErrorMessageState(errorMsg: "No se pudo guardar la imagen");
      }
    }
  }

  Future<String> _uploadFile() async {
    try {
      var stamp = DateTime.now();
      if (_selectedPicture == null) return null;
      UploadTask task = FirebaseStorage.instance
          .ref("noticias/imagen_$stamp.png")
          .putFile(_selectedPicture);
      await task;
      return await task.storage
          .ref("noticias/imagen_$stamp.png")
          .getDownloadURL();
    } on FirebaseException catch (e) {
      print("Error al subir la imagen: $e");
      return null;
    } catch (e) {
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  Future<bool> _saveNoticias(Noticia noticia) async {
    try {
      await _cFirestore.collection("noticias").add(noticia.toJson());
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<File> _getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected');
      return null;
    }
  }
}
