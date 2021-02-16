import 'package:flutter/cupertino.dart';

class NoteInsert{
  String noteTitle;
  String noteText;
  NoteInsert({@required this.noteText,@required this.noteTitle});

 Map<String,dynamic> toJson(){
    return{
      "noteTitle":Title,
      "noteText":Text

    };
  }
}
