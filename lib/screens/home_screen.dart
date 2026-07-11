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
      backgroundColor: const Color(0xffFFF5F7),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xffFF6B9D),
        title: const Text(
          "My Notes",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffFF6B9D)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    size: 90,
                    color: Colors.pink.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Notes Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap + to create your first note",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          final notes = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: ListView.separated(
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return NoteCard(
                  note: notes[index],

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
                          backgroundColor: const Color(0xffFF6B9D),
                          content: Text(result.toString()),
                        ),
                      );
                    }
                  },

                  onDelete: () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.white),
                              ),
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
                            backgroundColor: Color(0xffFF6B9D),
                            content: Text("Note deleted successfully"),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFF6B9D),
        elevation: 6,
        tooltip: "Add New Note",
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
          );

          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xffFF6B9D),
                content: Text(result.toString()),
              ),
            );
          }
        },
      ),
    );
  }
}
