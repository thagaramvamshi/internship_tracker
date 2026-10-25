
import 'package:flutter/material.dart';

import '../services/study_tips_service.dart';

class StudyTipsScreen extends StatefulWidget {
  const StudyTipsScreen({super.key});

  @override
  State<StudyTipsScreen> createState() => _StudyTipsScreenState();
}

class _StudyTipsScreenState extends State<StudyTipsScreen> {
  final StudyTipsService _service = StudyTipsService();

  Future<StudyTip>? _tipFuture;

  @override
  void initState() {
    super.initState();
    _loadTip();
  }

  void _loadTip() {
    setState(() {
      _tipFuture = _service.fetchStudyTip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Tips'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FutureBuilder<StudyTip>(
              future: _tipFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading inspiration...'),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined, size: 56),
                      const SizedBox(height: 12),
                      const Text('Could not load a tip.'),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadTip,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  );
                }

                final tip = snapshot.data!;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 56,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Study Inspiration',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '“${tip.text}”',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '— ${tip.author}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _loadTip,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Get Another Tip'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
