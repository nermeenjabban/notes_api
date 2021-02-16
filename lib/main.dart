import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_api/services/notes_services.dart';
import 'package:notes_api/views/note_list.dart';

void SetUpLocator(){
  GetIt.I.registerLazySingleton(() => NotesServices());

}
void main() {
  SetUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "notes-api",
      color: Colors.pink,
      home: NoteList(),
    );
  }

}