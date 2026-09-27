import 'package:bmw_app/logging/rename_log_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('rename dialog submits and disposes its text field safely', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showDialog<String>(
                  context: context,
                  builder: (_) => const RenameLogDialog(
                    title: 'Rename data log',
                    initialName: 'Original',
                  ),
                );
              },
              child: const Text('Open rename'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open rename'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Bench pull');
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();

    expect(result, 'Bench pull');
    expect(tester.takeException(), isNull);
  });
}
