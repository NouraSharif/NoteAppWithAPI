import 'package:flutter/material.dart';

class CardNotes extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? onTap;
  final Widget? trailing;
  const CardNotes({
    super.key,
    required this.title,
    required this.content,
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
          title: Text(title),
          subtitle: Text(content),
          trailing: trailing,
        ),
      ),
    );
  }
}
