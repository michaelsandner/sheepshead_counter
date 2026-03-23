import 'package:flutter/material.dart';

class PlayerNameField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback? onRemove;

  const PlayerNameField({
    super.key,
    required this.controller,
    required this.label,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
            ),
          ),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.red,
          ),
      ],
    );
  }
}
