import 'package:flutter/material.dart';
import 'package:my_notes/db_helper.dart/notes_db_helper.dart';
import 'package:my_notes/models/note_model.dart';
import 'package:my_notes/screens/add_notes.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  List<Note> notes;

Future<void> initData() async{
  notes=[];
List<Map<String,dynamic>> noteList=await DBHelper.getData();
  for(int i=0;i<noteList.length;i++){
    Note newNote=Note(
      id: noteList[i]['id'],
      title: noteList[i]['title'],
      description: noteList[i]['description'],
      date: noteList[i]['date'],
    );
    notes.add(newNote); 
  }
  setState((){
  });
}

void deleteNote(Note note) async{
  DBHelper.deleteData(note.id);
 await initData();
}

void addOrUpdateNote(String mode,{Note note})async{
  if(mode=='update'){
  await Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddOrUpdate(mode,note: note,)));
  }
  else{
  await Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddOrUpdate('add')));
  }
  await initData();
}
  @override
  void initState() {
    super.initState();
    initData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY NOTES'),
        centerTitle: true,
      ),
      body: notes.isEmpty
      ?Center(child:Text("No Notes"))
      : ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount:notes.length ,
        itemBuilder: (context,index)=>Card(
          elevation: 5,
                  child: ListTile(
                    
            
            title: Text(notes[index].title,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),),
            subtitle: Container(
              margin: EdgeInsets.only(top:10),
              child: Text(notes[index].date)),
            trailing: IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: (){
              deleteNote(notes[index]);
            }),
            leading: CircleAvatar(
              radius: 15,
              child: Icon(Icons.radio_button_checked,size: 30,),
            ),
            onTap:(){
              addOrUpdateNote('update',note: notes[index]);
            } ,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add) ,
        onPressed: (){
        addOrUpdateNote('add');
      }),
      
    );
  }
}