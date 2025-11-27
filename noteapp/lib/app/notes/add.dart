import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/components/customtextform.dart';
import 'package:noteapp/components/valid.dart';
import 'package:noteapp/constant/linkapi.dart';
import 'package:noteapp/main.dart';
import 'dart:typed_data'; //==Unit8List

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

  //switch to Uint8List[File]==>لاني بستخدم فلاتر ويب وليس فلاتر موبايل
  Uint8List? myfile;

  addNotes() async {
    if (myfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please choose an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await crud.postRequestWithFile(
        linkAddNote,
        {
          "title": title.text,
          "content": content.text,
          "id": prefs.getString("id"),
        },
        myfile!,
        "anyname.png",
        /*
      الصورة أصلًا أصبحت Uint8List
هذا النوع لا يملك اسم ملف      
ولكن الرفع (MultipartFile) يحتاج اسم، ولو افتراضي      
      */
      );
      isLoading = false;
      setState(() {});
      if (response["status"] == "success") {
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        print("Error: In add");
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
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 150,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera),
                                      title: Text("Camera"),
                                      onTap: () async {
                                        // Add your camera functionality here
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.camera,
                                            );
                                        Navigator.of(context).pop();
                                        // myfile = File(xfile!.path);
                                        if (xfile != null) {
                                          myfile =
                                              await xfile
                                                  .readAsBytes(); // مهم للويب
                                          setState(() {});
                                        }
                                        
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text("Gallery"),
                                      onTap: () async {
                                        // Add your gallery functionality here
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        Navigator.of(context).pop();
                                        if (xfile != null) {
                                          myfile =
                                              await xfile
                                                  .readAsBytes(); // مهم للويب
                                          setState(() {});
                                        }
                                        
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Choose Image"),
                        color: myfile == null ? Colors.blue : Colors.green,
                        textColor: Colors.white,
                      ),
                      Container(height: 10),
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
