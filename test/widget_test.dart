import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/providers/internship_provider.dart';
import 'package:internship_tracker/providers/profile_provider.dart';
import 'package:internship_tracker/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> loadApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => InternshipProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: const InternshipTrackerApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
  }

  testWidgets('Internship Tracker dashboard loads', (tester) async {
    await loadApp(tester);

    expect(find.text('Application Overview'), findsOneWidget);
    expect(find.text('Your career journey starts here.'), findsOneWidget);
    expect(find.text('Application Insights'), findsOneWidget);
  });

  testWidgets('Dashboard contains all six statistic cards', (tester) async {
    await loadApp(tester);

    final scrollable = find
        .descendant(
          of: find.byType(ListView).first,
          matching: find.byType(Scrollable),
        )
        .first;

    for (final title in [
      'Total',
      'Applied',
      'Interviews',
      'Assessments',
      'Selected',
      'Rejected',
    ]) {
      await tester.scrollUntilVisible(
        find.text(title).first,
        250,
        scrollable: scrollable,
      );

      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('Dashboard renders without crashing', (tester) async {
    await loadApp(tester);

    expect(find.byType(Scaffold), findsWidgets);
    expect(find.text('Application Overview'), findsOneWidget);
  });
}
