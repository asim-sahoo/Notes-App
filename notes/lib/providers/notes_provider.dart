import 'package:flutter/cupertino.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/api_service.dart';

class NotesProvider with ChangeNotifier {

  bool isLoading = true;
  List<Note> notes = [];

  NotesProvider() {
    fetchNotes();
  }

  void sortNotes() {
    notes.sort((a, b) => b.date!.compareTo(a.date!));
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void updateNote(Note note) {
    int indexOfNote = notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote = notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes() async {
  isLoading = true;
  notifyListeners();

  try {
    notes = await ApiService.fetchNotes("asim2");
  } catch (e) {
    // Handle error here, for example by displaying an error message to the user
    print("Error fetching notes: $e");
  }

  isLoading = false;
  notifyListeners();
}

}