import 'package:flutter/material.dart';
import '../models/note.dart';
import 'notes_form.dart';

class NotesDetail extends StatelessWidget {
  const NotesDetail({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text(note.title ?? "Sem título")),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '${note.description}',
                style: const TextStyle(fontSize: 15),
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                note.created_at ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                note.updated_at ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new NotesForm()));
        },
        tooltip: 'Editar nota',
        child: const Icon(Icons.edit),
      ),
  );
}