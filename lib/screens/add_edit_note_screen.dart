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

      message = "Note saved successfully";
    } else {
      await firestoreService.updateNote(
        NoteModel(
          id: widget.note!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );

      message = "Note updated successfully";
    }

    if (mounted) {
      Navigator.pop(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;

    return Scaffold(
      backgroundColor: const Color(0xffFFF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffFF6B9D),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          isEdit ? "Edit Note" : "Add Note",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      prefixIcon: const Icon(
                        Icons.title,
                        color: Color(0xffFF6B9D),
                      ),
                      filled: true,
                      fillColor: const Color(0xffFFF5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 90),
                        child: Icon(
                          Icons.description,
                          color: Color(0xffFF6B9D),
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xffFFF5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: saveNote,
                      icon: Icon(
                        isEdit ? Icons.edit : Icons.save,
                        color: Colors.white,
                      ),
                      label: Text(
                        isEdit ? "Update Note" : "Save Note",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF6B9D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
