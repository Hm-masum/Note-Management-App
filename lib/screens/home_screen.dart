import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/firestore_service.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes Management"), centerTitle: true),
      body: StreamBuilder<List<NoteModel>>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Notes Found", style: TextStyle(fontSize: 18)),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NoteCard(
                note: notes[index],

                // Edit Note
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditNoteScreen(note: notes[index]),
                    ),
                  );

                  if (result != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.toString()),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },

                // Delete Note
                onDelete: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Note"),
                        content: const Text(
                          "Are you sure you want to delete this note?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await firestoreService.deleteNote(notes[index].id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Note deleted successfully"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add New Note",
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
          );

          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.toString()),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
