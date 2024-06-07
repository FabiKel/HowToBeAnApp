import 'package:flutter/material.dart';

class BasicListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Icon? leading;
  final String? trailing;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool hideLeading;

  const BasicListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.hideLeading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(fontSize: 18),
            ),
      leading:
          hideLeading ? null : leading ?? const Icon(Icons.circle, size: 12),
      trailing: trailing == null
          ? null
          : Text(
              trailing!,
              style: const TextStyle(fontSize: 22),
            ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
