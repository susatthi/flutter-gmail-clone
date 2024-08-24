import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'material.dart';

part 'main.g.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentItem = ref.watch(navigationItemNotifierProvider);
    return Scaffold(
      body: SafeArea(child: currentItem.body),
      bottomNavigationBar: const BottomNavigationBar(),
    );
  }
}

@riverpod
class NavigationItemNotifier extends _$NavigationItemNotifier {
  @override
  NavigationItem build() {
    return NavigationItem.values.first;
  }

  void select(NavigationItem item) {
    state = item;
  }
}

enum NavigationItem {
  mail,
  video,
  ;

  IconData get icon => switch (this) {
        mail => Icons.email_outlined,
        video => Icons.videocam_outlined,
      };

  IconData get selectedIcon => switch (this) {
        mail => Icons.email,
        video => Icons.videocam,
      };

  Widget get body => switch (this) {
        mail => const MailBody(),
        video => const VideoBody(),
      };
}

class BottomNavigationBar extends ConsumerWidget {
  const BottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentItem = ref.watch(navigationItemNotifierProvider);
    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: 56,
      color: context.surfaceContainerLowest,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...NavigationItem.values.map(
            (item) => Expanded(
              child: InkWell(
                onTap: () => ref
                    .read(navigationItemNotifierProvider.notifier)
                    .select(item),
                child: Icon(
                  item == currentItem ? item.selectedIcon : item.icon,
                  size: 28,
                  color: context.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MailBody extends StatelessWidget {
  const MailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SearchMailAnchor(),
        ),
      ],
    );
  }
}

class SearchMailAnchor extends StatelessWidget {
  const SearchMailAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return SizedBox(
          height: 48,
          child: SearchBar(
            controller: controller,
            hintText: 'メールを検索',
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
            trailing: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person),
              ),
            ],
            elevation: WidgetStateProperty.all(2),
            backgroundColor:
                WidgetStateProperty.all(context.surfaceContainerLowest),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
      suggestionsBuilder: (context, controller) {
        return [];
      },
    );
  }
}

class VideoBody extends StatelessWidget {
  const VideoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('video');
  }
}
