import 'package:flutter/material.dart';

class RenameLogDialog extends StatefulWidget {
  const RenameLogDialog({
    super.key,
    required this.title,
    required this.initialName,
  });

  final String title;
  final String initialName;

  @override
  State<RenameLogDialog> createState() => _RenameLogDialogState();
}

class _RenameLogDialogState extends State<RenameLogDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() => Navigator.of(context).pop(controller.text);

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: controller,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(suffixText: '.csv'),
      onSubmitted: (_) => submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: submit, child: const Text('Rename')),
    ],
  );
}
