import 'package:flutter/material.dart';
import 'package:noteapp/app/notes/edit.dart';
import 'package:noteapp/components/cardnote.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/constant/linkapi.dart';
import 'package:noteapp/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = Crud();
  getNotes() async {
    var response = await crud.postRequest(linkViewNote, {
      "id": prefs.getString("id"),
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              prefs.clear();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loding..........."));
            }
            var data = snapshot.data as Map;
            if (data["status"] == 'fail') {
              return Center(child: Text("No Notes Found"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: data['data'].length,
                //الت\قيق ع هاي الميزتين
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                //----------------------------
                itemBuilder: (context, i) {
                  return CardNotes(
                    title: data['data'][i]["notes_title"].toString(),
                    content: data['data'][i]["notes_content"].toString(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => EditNotes(notes: data['data'][i]),
                        ),
                      );
                    },
                    trailing: IconButton(
                      color: Colors.blue,
                      onPressed: () async {
                        var response = await crud.postRequest(linkDeleteNote, {
                          "id": data["data"][i]["notes_id"].toString(),
                        });
                        if (response["status"] == "success") {
                          Navigator.of(context).pushReplacementNamed("home");
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                },
              );
            }

            return Center(child: Text("Loding..........."));
          },
        ),
      ),
    );
  }
}
