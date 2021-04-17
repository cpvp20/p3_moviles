import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/bloc/auth_bloc.dart';
import 'package:noticias/home/home_page.dart';
import 'package:noticias/login/login_page.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // inicializar firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // inicializar hive (almacenamiento local)
  final _localStorage = await getExternalStorageDirectory();
  Hive
    ..init(_localStorage.path)
    ..registerAdapter(NoticiaAdapter());
  await Hive.openBox("Noticias");

  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(VerifyAuthenticationEvent()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AlreadyAuthState) return HomePage();
          if (state is UnAuthState) return LoginPage();
          return SplashScreen();
        },
      ),
    );
  }
}
