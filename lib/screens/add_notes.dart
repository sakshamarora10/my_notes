import 'package:flutter/material.dart';
import 'package:my_notes/db_helper.dart/notes_db_helper.dart';
import 'package:my_notes/models/note_model.dart';
import 'package:intl/intl.dart';

class AddOrUpdate extends StatefulWidget {
 final  String mode;
  final Note note;
  AddOrUpdate(this.mode,{this.note});
  @override
  _AddOrUpdateState createState() => _AddOrUpdateState();
}

class _AddOrUpdateState extends State<AddOrUpdate> {
  TextEditingController _titleController;
  
  
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController=TextEditingController(
    text: widget.mode=="update"?widget.note.title:"",
  );
  _descriptionController=TextEditingController(
    text: widget.mode=="update"?widget.note.description:"",
  );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void _formSubmit() async{

if(_descriptionController.text.isEmpty&&_titleController.text.isEmpty){
Navigator.of(context).pop();
return;
}



if(widget.mode=='add'){
  Note note=Note(
    id: DateTime.now().toString(),
    title: _titleController.text.isEmpty?"No Title":_titleController.text,
    description: _descriptionController.text,
    date: DateFormat( DateFormat.YEAR_ABBR_MONTH_DAY).format(DateTime.now()),
  );

  await DBHelper.insertData({
    'id':note.id,
    'title':note.title,
    'description':note.description,
    'date':note.date,
  });

  

}

else if(widget.mode=='update'){
   Note note=Note(
    id: widget.note.id,
    title: _titleController.text.isEmpty?"No Title":_titleController.text,
    description: _descriptionController.text,
    date:DateFormat( DateFormat.YEAR_ABBR_MONTH_DAY).format(DateTime.now()),
  );
await DBHelper.updateData(widget.note.id, {
 'id':note.id,
  'title':note.title,
  'description':note.description,
  'date':note.date,
});

}
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mode} Note'.toUpperCase()),
        centerTitle: true,
        
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: _formSubmit)
        ],
      ),
      body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top:10),
                padding: EdgeInsets.all(8),
                child: Column(
          children: <Widget>[
            TextField(
            
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  labelText: 'Title'
                ),
                controller:_titleController,
            ),
            SizedBox(height: 30,),
            Container(
                height: MediaQuery.of(context).size.height*0.7,
                              child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: null,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    labelText: 'Description',
                  ),
                  controller: _descriptionController,
                ),
            )
          ],
        ),
              ),
      ),
      
    );
  }
}