import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/firestore_service.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void saveNote() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    String message;

    if (widget.note == null) {
      await firestoreService.addNote(
        NoteModel(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );

      message = "✅ Note saved successfully";
    } else {
      await firestoreService.updateNote(
        NoteModel(
          id: widget.note!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );

      message = "✅ Note updated successfully";
    }

    if (mounted) {
      Navigator.pop(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Note" : "Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveNote,
                child: Text(isEdit ? "Update Note" : "Save Note"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
