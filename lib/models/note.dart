import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/encrypt_service.dart';

class Note {
  String? _id;
  String? _title;
  String? _description;
  String? _origin;
  String? _created_at;
  String? _updated_at;

  Note(this._id, this._title, this._description, this._origin, this._created_at, this._updated_at);

  Note.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._origin = obj['origin'];
    this._created_at = obj['created_at'];
    this._updated_at = obj['updated_at'];
  }

  Note.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final objData = snapshot.data();

    try {
      this._description = EncryptService().decrypt(
          objData?['description']);
    } catch (e) {
      this._description = objData?['description'];
    }

    this._id = snapshot.id;
    this._title = objData?['title'];
    this._origin = objData?['origin'];
    this._created_at = objData?['created_at'];
    this._updated_at = objData?['updated_at'];
  }

  String? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get origin => _origin;
  String? get created_at => _created_at;
  String? get updated_at => _updated_at;

  Map<String, dynamic> toMap() {
    var encryptedDescription = EncryptService().encrypt(_description);

    return {
      if (_id != null) "id": _id,
      if (_title != null) "title": _title,
      if (_description != null) "description": encryptedDescription,
      if (_origin != null) "origin": _origin,
      if (_created_at != null) "created_at": _created_at,
      if (_updated_at != null) "updated_at": _updated_at,
    };
  }
}