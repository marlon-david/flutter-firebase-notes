import 'package:flutter/material.dart';
import 'package:private_notes/models/note.dart';
import 'package:private_notes/pages/notes_list.dart';
import '../util/firebase_helper.dart';
import 'error_page.dart';
import 'notes_form_presenter.dart';

class NotesForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesFormState();
}

class _NotesFormState extends State<NotesForm> implements NotesFormContract {
  BuildContext? _ctx;
  bool _initialized = false;
  bool _error = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String? _title, _description;
  NotesFormPresenter? _presenter;

  _NotesFormState() {
    _presenter = new NotesFormPresenter(this);
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await FirebaseHelper.initializeFlutterFire();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void _register() {
    Navigator.of(context).pushNamed("/register");
  }

  void _submit() {
    final FormState? form = formKey.currentState;

    if (form == null) {
      print("form is null");
      return;
    }

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        print("Entrou 01");
        _presenter?.doSubmit(_title!, _description!);
      });
    } else {
      print("form not validate");
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    // if (FirebaseHelper.isLogged) {
    //   Navigator.of(this.context).pushNamed("/home");
    // }
    super.initState();
  }

  void _showSnackBar(String text) {
    // scaffoldKey.currentState.showSnackBar(new SnackBar(
    //   content: new Text(text),
    // ));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return ErrorPage();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final Size screenSize = MediaQuery.of(context).size;
    _ctx = context;

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor: Colors.green,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    var loginBtn = new ElevatedButton(
        onPressed: _submit, child: new Text("Criar"), style: raisedButtonStyle);

    var createForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Nova nota",
          textScaleFactor: 2.0,
        ),
        new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite um título';
                        }
                        return null;
                      },
                      onSaved: (val) => _title = val,
                      decoration: new InputDecoration(labelText: "Título"),
                    )),
                new Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new TextFormField(
                      onSaved: (val) => _description = val,
                      decoration: new InputDecoration(labelText: "Descrição"),
                      maxLines: 5,
                    ))
              ],
            )),
        new Padding(
            padding: new EdgeInsets.all(10.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : loginBtn),
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Nova nota'),
        ),
        key: scaffoldKey,
        body: new Container(
            child: new Center(
              child: createForm,
            )));
  }

  @override
  void onFormError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onFormSuccess(Note note) async {
    print("entrou no onFormSuccess");

    _showSnackBar(note.toString());
    setState(() {
      _isLoading = false;
    });

    if (note.id != null) {
      print("salvo");
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new NotesList()
      ));
    } else {
      print("Nao salvo");
    }
  }
}