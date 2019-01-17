import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'dart:async';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String> [
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(this.todo);
}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context){
              return choices.map((String choice){
                  return PopupMenuItem(
                    value: choice,
                    child:  new Container(
                          child: new Card(
                            child: new Row(children: <Widget>[
                              new Icon(Icons.menu),
                              new Text(choice),
                            ]),
                          ),
                          // color: Colors.deepOrangeAccent,
                          alignment: Alignment.center,//Alignment(0.0, 0.0),
                        ),
                  );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: ListView(
          children: <Widget>[ 
            Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              ListTile(
                              title: DropdownButton<String>(
                    style: textStyle,
                    // isExpanded: true,
                    items: _priorities.map((String val) {
                      return new DropdownMenuItem<String>(
                        value: val,
                        child: new Container(
                          child: new Card(
                            child: new Row(children: <Widget>[
                              new Icon(Icons.low_priority),
                              new Text(val),
                            ]),
                          ),
                          // color: Colors.deepOrangeAccent,
                          alignment: Alignment.center,//Alignment(0.0, 0.0),
                        ),
                      );
                    }).toList(),
                    hint: new Card(
                        child: new Row(children: <Widget>[
                      new Icon(Icons.low_priority),
                      new Text("check"),
                    ])),
                    value: _priority,
                    onChanged: (newVal) {
                      _priority = newVal;
                      setState(() {});
                    }),
              )
            ],
          ),
          ],
        ),
      ),
    );
  }

  Future select (String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
      Navigator.pop(context,true);
        if (todo.id == null) {
          return;
        }
        result = await helper.deleteTodo(todo.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted"),
          );
          showDialog(
            context: context,
            builder: (_) => alertDialog
          );
        }
        break;
       case mnuBack:
        Navigator.pop(context,true);
        //save();
        break;       
      default:
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if(todo.id !=null) {
      helper.updateTodo(todo);
    }
    else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context,true);

  }
}
