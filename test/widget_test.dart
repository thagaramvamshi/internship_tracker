
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/providers/internship_provider.dart';
import 'package:internship_tracker/providers/profile_provider.dart';
import 'package:internship_tracker/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Internship Tracker dashboard loads', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => InternshipProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProfileProvider(),
          ),
        ],
        child: const InternshipTrackerApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Application Overview'), findsOneWidget);
    expect(find.text('Your career journey starts here.'), findsOneWidget);
  });
}
