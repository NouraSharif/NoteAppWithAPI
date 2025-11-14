import 'package:flutter/material.dart';
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
          leading: Image.asset("images/notes2.png"),
          title: Text("${notemodel.notesTitle}"),
          subtitle: Text("${notemodel.notesContent}"),
          trailing: trailing,
        ),
      ),
    );
  }
}
