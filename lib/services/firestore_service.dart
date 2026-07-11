import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collectionName = "notes";

  // Create Note
  Future<void> addNote(NoteModel note) async {
    await _firestore.collection(collectionName).add(note.toMap());
  }

  // Read Notes
  Stream<List<NoteModel>> getNotes() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => NoteModel.fromDocument(doc)).toList();
    });
  }

  // Update Note
  Future<void> updateNote(NoteModel note) async {
    await _firestore
        .collection(collectionName)
        .doc(note.id)
        .update(note.toMap());
  }

  // Delete Note
  Future<void> deleteNote(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
