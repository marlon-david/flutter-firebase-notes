import 'package:private_notes/models/note.dart';
import 'package:private_notes/pages/notes_detail.dart';
import 'package:private_notes/repositories/note_repository.dart';
import 'package:private_notes/util/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'notes_form.dart';

class NotesList extends StatefulWidget {
  @override
  _MyNotesListState createState() => new _MyNotesListState();
}

class _MyNotesListState extends State<NotesList> {
  bool _initialized = false;
  bool _error = false;
  bool _isLoading = false;
  List<dynamic> data = [];

  void makeRequest() async {
    NoteRepository repository = new NoteRepository();
    var response = repository.getList();

    // data.add(new Note(null, "Item 1", ""));
    // data.add(new Note(null, "Item 2", ""));

    response.then(
      (querySnapshot) {
        setState(() {
          _isLoading = false;
          for (var docSnapshot in querySnapshot.docs) {
            data.add(Note.fromFirestore(docSnapshot));
          }
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<void> initializeFlutterFire() async {
    try {
      await FirebaseHelper.initializeFlutterFire();
      setState(() {
        _initialized = true;
        makeRequest();
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    _isLoading = true;
    this.initializeFlutterFire();
    // FirebaseHelper.listenAuthActions(this.context, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text('Lista de notas')),
      body: new ListView.builder(
          itemCount: data.isEmpty ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return new ListTile(
                title: new Text(data[i].title),
                subtitle: new Text(data[i].id.toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new NotesDetail(note: data[i])));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new NotesForm()
          ))
        },
        tooltip: 'Criar nova',
        child: const Icon(Icons.add),
      ),
    );
  }
}
