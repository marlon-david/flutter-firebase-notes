import 'package:private_notes/models/note.dart';
import '../repositories/note_repository.dart';

abstract class NotesFormContract {
  void onFormSuccess(Note note);
  void onFormError(String error);
}

class NotesFormPresenter {
  NotesFormContract _view;
  NoteRepository repository = new NoteRepository();
  NotesFormPresenter(this._view);

  doSubmit(String title, String description) {
    repository
        .create(title, description)
        .then((note) => _view.onFormSuccess(note))
        .catchError((onError) => _view.onFormError(onError.toString()));
  }
}