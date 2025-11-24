import 'package:flutter/material.dart';
import 'package:noteapp/constant/linkapi.dart';
import 'package:noteapp/model/notemodel.dart';

class CardNotes extends StatelessWidget {
  final NoteModel notemodel;
  final void Function()? onTap;
  final Widget? trailing;
  const CardNotes({
    super.key,
    required this.notemodel,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "$linkImageServer${notemodel.notesImage}",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              //headers: {'Accept': '*/*', 'User-Agent': 'Flutter'},
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.red);
              },
            ),
          ),
          title: Text("${notemodel.notesTitle}"),
          subtitle: Text("${notemodel.notesContent}"),
          trailing: trailing,
        ),
      ),
    );
  }
}
