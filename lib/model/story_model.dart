import 'dart:convert';

import 'package:story_teller_admin/model/author_model.dart';
import 'package:story_teller_admin/model/category_model.dart';

class StoryModel {
  int? id;
  CategoryModel? category;
  AuthorModel? author;
  String? name;
  String? image;
  String? tags;
  StoryModel({
    this.id,
    this.category,
    this.author,
    this.name,
    this.image,
    this.tags,
  });

  StoryModel copyWith({
    int? id,
    CategoryModel? category,
    AuthorModel? author,
    String? name,
    String? image,
    String? tags,
  }) {
    return StoryModel(
      id: id ?? this.id,
      category: category ?? this.category,
      author: author ?? this.author,
      name: name ?? this.name,
      image: image ?? this.image,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (category != null) {
      result.addAll({'category': category!.toMap()});
    }
    if (author != null) {
      result.addAll({'author': author!.toMap()});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (tags != null) {
      result.addAll({'tags': tags});
    }

    return result;
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id']?.toInt(),
      category: map['category'] != null
          ? CategoryModel.fromMap(map['category'])
          : null,
      author: map['author'] != null ? AuthorModel.fromMap(map['author']) : null,
      name: map['name'],
      image: map['image'],
      tags: map['tags'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StoryModel(id: $id, category: $category, author: $author, name: $name, image: $image, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoryModel &&
        other.id == id &&
        other.category == category &&
        other.author == author &&
        other.name == name &&
        other.image == image &&
        other.tags == tags;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category.hashCode ^
        author.hashCode ^
        name.hashCode ^
        image.hashCode ^
        tags.hashCode;
  }
}
