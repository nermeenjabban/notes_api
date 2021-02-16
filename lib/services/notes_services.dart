import 'dart:convert';
import 'package:notes_api/models/api_responce.dart';
import 'package:notes_api/models/note.dart';

import 'package:notes_api/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import  "dart:convert";

import 'package:notes_api/models/note_insert.dart';

class NotesServices
{
  static const API_Url = "http://192.168.43.224/notes_api_php/api/notes/";



  Future  <APIResponce<Note>> getNote(String id) async {
    String path = API_Url + 'note_byid.php?id=' + id;
    http.Response response = await http.get(path);
   // if (json.decode(response.body)["result"] == "success") {
    if(response.statusCode==200){
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print("jsondata:");
      final jsonData = json.decode(response.body);
      print("jsondata:");
      print(jsonData);
     // final notes =<NoteForListing>[];
      final note=Note(
        noteID: jsonData['id'],
        noteTitle: jsonData['Title'],
         noteText:jsonData['Text'],
        createDateTime: DateTime.parse(jsonData['createDateTime']),
        lastEditDateTime: DateTime.parse(jsonData['lastEdit']),
      );
      print("notes");
      //notes.add(note);
      //print(notes);
      return APIResponce<Note>(data: note);
    }
    return APIResponce<Note>(
        error: true, errorMessage: "fail");

  }


  Future <APIResponce<List<NoteForListing>>> getNoteList() async {
    String path = API_Url + 'select_notes.php';
    http.Response response = await http.get(path);
    print(path);
    if(response.statusCode==200){
      print("pppppppppppppppp");
      final jsonData = json.decode(response.body);
      print("jsonData:");
      print(response.body.toString());
      final notes = <NoteForListing>[];
      for (var item in jsonData) {
        final note = NoteForListing(
          noteID: item['id'],
          noteTitle: item['Title'],
          createDateTime: DateTime.parse(item['createDateTime']),
          lastEditDateTime: DateTime.parse(item['lastEdit']),
        );
        print("sssssssss");
        notes.add(note);
      }
        return APIResponce<List<NoteForListing>>(data: notes);
      }
      return APIResponce<List<NoteForListing>>(
          error: true, errorMessage: "fail");
    }


  static Future <APIResponce<bool>> deleteNote(String id) async{
    String path = API_Url + 'delete_note.php?id=' + id;
    http.Response response = await http.delete(path);
    if (json.decode(response.body)["result"] == "success") {
      print("kkkkkkkkkkk");
      return APIResponce<bool>(data: true);
    }
    return APIResponce<bool>(
        error: true, errorMessage: "fail");
  }


   Future <APIResponce<bool>> createNote(NoteInsert item) async{
    String path = API_Url + 'insert_note.php?Title='+item.noteTitle+'&Text='+item.noteText;
    print(path);
   // http.Response response = await http.post(path,body: item.toJson());
    http.Response response = await http.post(path);
    if(response.statusCode==200){
      print("kkkkkkkkkkk");
      return APIResponce<bool>(data: true);
    }
    return APIResponce<bool>(
        error: true, errorMessage: "fail");
  }

  Future <APIResponce<bool>> updateNote(NoteInsert item,String ID) async{
    String path = API_Url + 'update_note.php?Title='+item.noteTitle+'&Text='+item.noteText+'&id='+ID;
    print(path);
    // http.Response response = await http.post(path,body: item.toJson());
    http.Response response = await http.put(path);
    if(response.statusCode==200){
      print("kkkkkkkkkkk");
      return APIResponce<bool>(data: true);
    }
    return APIResponce<bool>(
        error: true, errorMessage: "fail");
  }




}


