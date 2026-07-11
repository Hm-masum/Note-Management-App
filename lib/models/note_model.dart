import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? id;
  String title;
  String description;

  NoteModel({this.id, required this.title, required this.description});

  // Convert Object to Firestore Map
  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description};
  }

  // Convert Firestore Document to Object
  factory NoteModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
