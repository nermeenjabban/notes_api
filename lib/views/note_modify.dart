import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_api/models/note.dart';

import 'package:notes_api/models/note_for_listing.dart';
import 'package:notes_api/models/note_insert.dart';
import 'package:notes_api/services/notes_services.dart';

// ignore: must_be_immutable
class NoteModify extends StatefulWidget{
  final String noteID;

  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID !=null;
  NotesServices get noteServices =>GetIt.I<NotesServices>();
 String errorMessage;
  //NoteForListing note;
  Note note;
 //
  //List<NoteForListing> note;
  //<APIResponce<List<NoteForListing>>> note;
  TextEditingController textController=new TextEditingController();

  TextEditingController titleController=new TextEditingController();
  bool isLoading=false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(isEditing){
      setState(() {
        isLoading=true;
      });
      noteServices.getNote(widget.noteID).then((response){
        setState(() {
          isLoading=false;
        });
        if(response.error){
          errorMessage=response.errorMessage ?? "An error";
        }
        note=response.data;
        titleController.text=note.noteTitle;
        textController.text=note.noteText;
      });

    }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
           isEditing? "Edit node":"Create node",
        ),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child:isLoading? Center(child:CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: titleController,
             decoration: InputDecoration(
               hintText: "Title"
             ),
            ),

            Container(height: 6,),
            TextField(
              controller: textController,
                decoration: InputDecoration(
                    hintText: "Text"
                )
            ),
            Container(height: 18,),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: RaisedButton(
                child: Text("Submit",
                    style:TextStyle(color:Colors.white) ,
                ),
                  color: Colors.pink,
                  onPressed: ()async{
                  if(isEditing){
                    setState(() {
                      isLoading=true;
                    });
                    final note=NoteInsert
                      (
                        noteTitle: titleController.text,
                        noteText: textController.text);
                    final result=await noteServices.updateNote(note,widget.noteID);
                    setState(() {
                      isLoading=false;
                      print("dddddddddddddddd");
                    });
                    final title="Done";
                    final text=result.error ? (result.errorMessage??"error") :"your notes was update";
                    showDialog(
                      context: context,
                      builder:(_) => AlertDialog(
                        title: Text(title),
                        content:Text(text),
                        actions: <Widget>[
                          FlatButton( child: Text("ok"),onPressed: (){
                            Navigator.of(context).pop();
                          })
                        ],
                      ),
                    )
                        .then((data)
                    {
                      if(result.data){
                        Navigator.of(context).pop();
                      }
                    });

                  }
                  else{
                    setState(() {
                      isLoading=true;
                    });
                    final note=NoteInsert
                      (
                        noteTitle: titleController.text,
                        noteText: textController.text);
                         final result=await noteServices.createNote(note);
                   setState(() {
                     isLoading=false;
                     print("dddddddddddddddd");
                   });
                   final title="Done";
                   final text=result.error ? (result.errorMessage??"error") :"your notes was created";
                    showDialog(
                      context: context,
                      builder:(_) => AlertDialog(
                        title: Text(title),
                        content:Text(text),
                        actions: <Widget>[
                          FlatButton( child: Text("ok"),onPressed: (){
                            Navigator.of(context).pop();
                          })
                        ],
                      ),
                    )
                    .then((data)
                    {
                      if(result.data){
                        Navigator.of(context).pop();
                      }
                    });

                  }

                  //Navigator.pop(context);
                  }
              ),
            )

          ],
        ),
      )
    );
  }
}