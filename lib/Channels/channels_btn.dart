import 'package:flutter/material.dart';

class Channels extends StatelessWidget {
  final String btnText;
  final bool isActive;
  final ValueChanged<String> onButtonPressed;

  const Channels({
    required this.btnText,
    required this.isActive,
    required this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(btnText),
      tileColor: isActive ? Colors.blue : Colors.transparent,
      onTap: () => onButtonPressed(btnText),
    );
  }
}
