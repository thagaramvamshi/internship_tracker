
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/providers/internship_provider.dart';

void main() {
  testWidgets('Internship Tracker dashboard loads', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InternshipProvider(),
        child: const InternshipTrackerApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Application Overview'), findsOneWidget);
    expect(find.text('Your career journey starts here.'), findsOneWidget);
  });
}
