import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'source.dart';

part 'noticia.g.dart';

@HiveType(typeId: 1, adapterName: 'NoticiaAdapter')
class Noticia extends Equatable {
  final Source source;
  @HiveField(0)
  final String author;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String urlToImage;
  @HiveField(5)
  final String content;
  @HiveField(6)
  const Noticia({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.content,
  });

  @override
  String toString() {
    return 'Noticia(source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, content: $content)';
  }

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source?.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'content': content,
    };
  }

  Noticia copyWith({
    Source source,
    String author,
    String title,
    String description,
    String url,
    String urlToImage,
    String content,
  }) {
    return Noticia(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      content: content ?? this.content,
    );
  }

  @override
  List<Object> get props {
    return [
      source,
      author,
      title,
      description,
      url,
      urlToImage,
      content,
    ];
  }
}
