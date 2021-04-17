import 'package:equatable/equatable.dart';

import 'noticia.dart';

class Noticias extends Equatable {
  final String status;
  final int totalResults;
  final List<Noticia> newsList;

  const Noticias({
    this.status,
    this.totalResults,
    this.newsList,
  });

  @override
  String toString() {
    return 'Noticias(status: $status, totalResults: $totalResults, articles: $newsList)';
  }

  factory Noticias.fromJson(Map<String, dynamic> json) {
    return Noticias(
      status: json['status'] as String,
      totalResults: json['totalResults'] as int,
      newsList: (json['articles'] as List)
          ?.map((e) => e == null
              ? null
              : Noticia.fromJson(json['articles'] as Map<String, dynamic>))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': newsList?.map((e) => e?.toJson())?.toList(),
    };
  }

  Noticias copyWith({
    String status,
    int totalResults,
    List<Noticia> newsList,
  }) {
    return Noticias(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      newsList: newsList ?? this.newsList,
    );
  }

  @override
  List<Object> get props => [status, totalResults, newsList];
}
