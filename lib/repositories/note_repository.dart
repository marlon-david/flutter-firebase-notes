import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class NoteRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  getList() async {
    final notes = db.collection("notes");

    return notes.get();
    notes.get().then((querySnapshot) => {
        for (var item in querySnapshot.docs) {
          //print('${item.id} => ${item.data()}');
          print(item.data())
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<Note> create(String title, String description) async {
    var data = Note(
      null,
      title,
      description,
      "flutter_app",
      DateTime.now().toString(),
      null
    ).toMap();

    Future<Note> note = db.collection("notes").add(data).then((documentSnapshot) {
        print("Added Data with ID: ${documentSnapshot.id}");
        data['id'] = documentSnapshot.id;
        return Note.map(data);
    });

    return note;
  }
}