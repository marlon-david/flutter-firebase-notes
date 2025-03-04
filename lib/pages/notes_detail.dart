import 'package:flutter/material.dart';
import '../models/note.dart';

class NotesDetail extends StatelessWidget {
  const NotesDetail({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text(note.title ?? "Sem título")),
      body: new Center(
        child: new Container(
          width: 250.0,
          height: 250.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
            border: new Border.all(color: Colors.red, width: 4.0),
          ),
          child: Text(note.description.toString(),
          style: const TextStyle(fontFamily: "monospace",
              fontFamilyFallback: <String>["Courier"]),
          softWrap: true)
        ),
      ));
}