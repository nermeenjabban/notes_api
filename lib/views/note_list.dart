
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_api/models/api_responce.dart';
import 'package:notes_api/models/note_for_listing.dart';
import 'package:notes_api/services/notes_services.dart';
import 'package:notes_api/views/note_delete.dart';
import 'note_modify.dart';



class NoteList extends StatefulWidget{

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  APIResponce<List<NoteForListing>> apiResponce;
// APIResponce<NoteForListing> Responce;
  bool isLoding=false;
  NotesServices get noteServices =>GetIt.I<NotesServices>();
  String formaldate(DateTime dateTime){
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }


  void initState(){

    fetchNode();
    super.initState();
  }
  fetchNode() async{
    setState(() {
      isLoding=true;
    });
//apiResponce=await noteServices.getNote('9');
 apiResponce=await noteServices.getNoteList();
   //apiResponce=await noteServices.test();
    setState(() {
      isLoding=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of node"),
        backgroundColor: Colors.pink,

      ),
      floatingActionButton: FloatingActionButton(
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteModify()
      ))
      .then((_){
        fetchNode();

      });
    },
    child: Icon(Icons.add),
        backgroundColor:Colors.pink ,
    ),
        body: Builder(
          builder: (_) {
            if(isLoding){
              return Center(child:
              CircularProgressIndicator());
            }
            if(apiResponce?.error){
              return Center(child: Text(apiResponce.errorMessage));
            }
         return  ListView.separated(
              separatorBuilder: (_, __)=> Divider(height: 1, color: Colors.black,),
              itemBuilder: (context,index){
                return Dismissible(
                  key:ValueKey(apiResponce.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction){},
                  confirmDismiss: (direction) async{
                    var message;
                    final result= await showDialog(
                      context: context,
                      builder: (_) => NoteDelete());
                      if(result){
                       final deleteResult= await NotesServices.deleteNote(apiResponce.data[index].noteID);
                       if(deleteResult !=null && deleteResult.data == true){
                          message="Note was deleted Successfully";
                       }
                       else{
                          message=deleteResult?.errorMessage ;
                       }
                       showDialog(
                         context: context,
                         builder:(_) => AlertDialog(
                           title: Text("Done"),
                           content:Text(message),
                           actions: <Widget>[
                             FlatButton( child: Text("ok"),onPressed: (){
                               Navigator.of(context).pop();
                             })
                           ],
                         ),
                       );
                       return deleteResult?.data??false;
                      }
                    return result;
                  },
                  background: Container(
                    color: Colors.pink,
                    padding: EdgeInsets.all(16),
                    child: Align(child:
                    Icon(
                        Icons.delete,
                        color:Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(apiResponce.data[index].noteTitle,
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    subtitle: Text("last editing on ${formaldate(apiResponce.data[index].lastEditDateTime??DateTime.now()
                    //apiResponce.data[index].createDateTime
                    )} " ),
                    onTap:(){
                      Navigator .of (context)
                          .push(MaterialPageRoute(builder: (_) => NoteModify(noteID:apiResponce.data[index].noteID))).then((data)
                          {
                            fetchNode();
                          }
                      );
                    },
                  ),
                );
              },
              itemCount: apiResponce.data.length,

            );

          },
        )

    );


  }
}