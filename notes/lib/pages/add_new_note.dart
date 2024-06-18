import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddNewNotePage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNewNotePage({ super.key, required this.isUpdate, this.note });

  @override
  _AddNewNotePageState createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  FocusNode noteFocus = FocusNode();

  void addNewNote() {
    Note newNote = Note(
      id: const Uuid().v1(),
      userid: "asim2",
      title: titleController.text,
      content: contentController.text,
      date: DateTime.now()
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.date = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if(widget.isUpdate) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        leading: Container(
          margin: const EdgeInsets.all(9.5),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 59,58,58), // Customize the color as needed
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 17,),
            
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          // Save button in a box with rounded corners
          GestureDetector(
            onTap: () {
              if (widget.isUpdate) {
                updateNote();
              } else {
                addNewNote();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 59,58,58), // Customize the color as needed
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextField(
                controller: titleController,
                autofocus: (widget.isUpdate == true) ? false : true,
                onSubmitted: (val) {
                  if(val != "") {
                    noteFocus.requestFocus();
                  }
                },
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,

                ),
              ),
              //created date
              const SizedBox(height: 10),
              Text(
                (widget.isUpdate)? DateFormat.yMMMd().format(DateTime.now()) : DateFormat.yMMMd().format(DateTime.now()), // Show the current date when adding a new note
                style: const TextStyle(
                  color: Color.fromARGB(255, 180, 180, 180),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextField(
                  controller: contentController,
                  focusNode: noteFocus,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 20,
                  color: Color.fromARGB(255, 236, 236, 236),

                  ),
                  decoration: const InputDecoration(
                    hintText: "Note",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}