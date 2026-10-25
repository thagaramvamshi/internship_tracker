
import 'package:flutter/material.dart';

import '../services/tips_service.dart';

class InternshipTipsScreen extends StatefulWidget {
  const InternshipTipsScreen({super.key});

  @override
  State<InternshipTipsScreen> createState() =>
      _InternshipTipsScreenState();
}

class _InternshipTipsScreenState
    extends State<InternshipTipsScreen> {
  final TipsService _tipsService = TipsService();

  late Future<CareerTip> _tipFuture;

  @override
  void initState() {
    super.initState();
    _loadTip();
  }

  void _loadTip() {
    setStateIfMounted(() {
      _tipFuture = _tipsService.fetchTip();
    });
  }

  void setStateIfMounted(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Tips'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FutureBuilder<CareerTip>(
              future: _tipFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading your career tip...'),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Could not load a tip.',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Check your internet connection and try again.',
                        textAlign: TextAlign.center,
                      ),
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
                          Icons.lightbulb_outline,
                          size: 56,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'A Little Inspiration',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '“${tip.text}”',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '— ${tip.author}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
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
