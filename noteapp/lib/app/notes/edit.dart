import 'package:flutter/material.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/components/customtextform.dart';
import 'package:noteapp/components/valid.dart';
import 'package:noteapp/constant/linkapi.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, required this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> with Crud {
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  editNotes() async {
    var response = await postRequest(linkEditNote, {
      "title": title.text,
      "content": content.text,
      "id": widget.notes["notes_id"].toString(),
    });
    if (response["status"] == "success") {
      Navigator.of(context).pushReplacementNamed("home");
    } else {
      //
    }
  }

  @override
  void initState() {
    title.text = widget.notes["notes_title"];
    content.text = widget.notes["notes_content"];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditNotes'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              CustTextFormSign(
                hint: widget.notes["notes_title"],
                mycontroller: title,
                valid: (val) {
                  return validInput(val!, 1, 10);
                },
              ),
              CustTextFormSign(
                hint: widget.notes["notes_content"],
                mycontroller: content,
                valid: (val) {
                  return validInput(val!, 1, 10);
                },
              ),

              MaterialButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async {
                  await editNotes();
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
