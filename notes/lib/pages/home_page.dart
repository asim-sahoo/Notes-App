import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/add_new_note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';
import 'dart:math'; // Import to use Random

final List<Color> noteColors = [
  const Color.fromARGB(255, 254, 204, 129),
  const Color.fromARGB(255, 254, 171, 144),
  const Color.fromARGB(255, 231, 238, 154),
  const Color.fromARGB(255, 128, 222, 234),
  const Color.fromARGB(255, 207, 147, 217),
  const Color.fromARGB(255, 128, 202, 197),
  const Color.fromARGB(255, 244, 143, 177),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        title: const Text(
          "Notes",
          style: TextStyle(
              fontSize: 37, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: (notesProvider.isLoading == false)
            ? SafeArea(
                child: (notesProvider.notes.isNotEmpty)
                    ? MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: notesProvider.notes.length,
                        itemBuilder: (context, index) {
                          Note currentNote = notesProvider.notes[index];
                          Color noteColor =
                              noteColors[index % noteColors.length];
                          String formattedDate =
                              DateFormat.yMMMd().format(currentNote.date!);
                          int maxLines = _random.nextInt(6) +
                              1; // Random number between 1 and 6

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => AddNewNotePage(
                                    isUpdate: true,
                                    note: currentNote,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              Vibration.vibrate(duration: 20, amplitude: 128);
                              notesProvider.deleteNote(currentNote);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(17),
                              decoration: BoxDecoration(
                                color: noteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentNote.title!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    currentNote.content!,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey[700]),
                                    maxLines: maxLines,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "No notes yet",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => const AddNewNotePage(
                      isUpdate: false,
                    )),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Makes the button round
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
