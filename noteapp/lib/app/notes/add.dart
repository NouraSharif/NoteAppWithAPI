import 'package:flutter/material.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/components/customtextform.dart';
import 'package:noteapp/components/valid.dart';
import 'package:noteapp/constant/linkapi.dart';
import 'package:noteapp/main.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false;
  Crud crud = Crud();

  addNotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await crud.postRequest(linkAddNote, {
        "title": title.text,
        "content": content.text,
        "id": prefs.getString("id"),
      });
      isLoading = false;
      setState(() {});
      if (response["status"] == "success") {
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddNotes'),
        backgroundColor: Colors.blue,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: formstate,
                  child: ListView(
                    children: [
                      CustTextFormSign(
                        hint: "title",
                        mycontroller: title,
                        valid: (val) {
                          validInput(val!, 1, 10);
                          return null;
                        },
                      ),
                      CustTextFormSign(
                        hint: "content",
                        mycontroller: content,
                        valid: (val) {
                          validInput(val!, 1, 40);
                          return null;
                        },
                      ),
                      Container(height: 20),
                      MaterialButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          await addNotes();
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
