import 'package:localstore/localstore.dart';

class FavoritesModel {
  final String id;
  String name;
  DateTime time;
  bool done;
  FavoritesModel({
    required this.id,
    required this.name,
    required this.time,
    required this.done,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time.millisecondsSinceEpoch,
      'done': done,
    };
  }

  factory FavoritesModel.fromMap(Map<String, dynamic> map) {
    return FavoritesModel(
      id: map['id'],
      name: map['name'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      done: map['done'],
    );
  }
}

extension ExtTodo on FavoritesModel {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('favs').doc(id).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('favs').doc(id).delete();
  }
}
