import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/components/customtextform.dart';
import 'package:noteapp/components/valid.dart';
import 'package:noteapp/constant/linkapi.dart';
import 'dart:typed_data'; //==Unit8List

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

  Uint8List? myfile;
  editNotes() async {
    var response;
    if (myfile != null) {
      response = await postRequestWithFile(
        linkEditNote,
        {
          "title": title.text,
          "content": content.text,
          "id": widget.notes["notes_id"].toString(),
          "imagename": widget.notes['notes_image'].toString(),
        },
        myfile!,
        "${DateTime.now().millisecondsSinceEpoch}.png",
      );
    } else {
      response = await postRequest(linkEditNote, {
        "title": title.text,
        "content": content.text,
        "id": widget.notes["notes_id"].toString(),
        "imagename": widget.notes['notes_image'].toString(),
      });
    }

    if (response["status"] == "success") {
      Navigator.of(context).pushReplacementNamed("home");
    } else {
      print("Error: ${response["status"]}");
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
                color: myfile == null ? Colors.blue : Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose Image Please:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                XFile? xfile = await ImagePicker().pickImage(
                                  source: ImageSource.camera,
                                );
                                Navigator.of(context).pop();
                                myfile = await xfile!.readAsBytes();
                                setState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 30, top: 5),
                                child: Text(
                                  "From Camera",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                XFile? xfile = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                Navigator.of(context).pop();
                                myfile = await xfile!.readAsBytes();
                                setState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  "From Gallery",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text("Choose Image"),
              ),
              Container(height: 10),
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
