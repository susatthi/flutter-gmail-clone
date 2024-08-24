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
      floatingActionButton: const ComposeEmailButton(),
    );
  }
}

class ComposeEmailButton extends StatelessWidget {
  const ComposeEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      icon: Icon(
        Icons.edit_outlined,
        color: context.error,
      ),
      label: Text(
        '作成',
        style: context.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.error,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: context.surfaceContainerLowest,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.shadow.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 56,
        color: context.surfaceContainerLowest,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...NavigationItem.values.map(
              (item) {
                final isSelected = item == currentItem;
                return Expanded(
                  child: InkWell(
                    onTap: () => ref
                        .read(navigationItemNotifierProvider.notifier)
                        .select(item),
                    child: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      size: 26,
                      color: isSelected ? context.error : context.outline,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MailBody extends StatelessWidget {
  const MailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SearchMailAnchor(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 1 + 20,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const InboxTitle();
              }
              return const MailTile();
            },
          ),
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
            trailing: const [
              PersonIconButton(),
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

class PersonIconButton extends StatelessWidget {
  const PersonIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        radius: 18,
        backgroundColor: context.primary,
        child: CircleAvatar(
          radius: 16,
          backgroundColor: context.onPrimary,
          child: const CircleAvatar(
            radius: 14,
            foregroundImage: NetworkImage(
              'https://pbs.twimg.com/profile_images/3229257541/0f3a5a42716a230e07619abc86d67b8d_400x400.png',
            ),
          ),
        ),
      ),
    );
  }
}

class InboxTitle extends StatelessWidget {
  const InboxTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 24, 8),
      child: Text(
        '受信トレイ',
        style: context.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.onSurfaceVariant,
        ),
      ),
    );
  }
}

class MailTile extends StatelessWidget {
  const MailTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      titleAlignment: ListTileTitleAlignment.top,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: const CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(
          'Y',
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'エクスプレス予約・スマートEX',
              maxLines: 1,
            ),
          ),
          Text(
            '8月23日',
            style: context.bodySmall,
          ),
        ],
      ),
      subtitleTextStyle: context.bodySmall?.copyWith(
        color: context.onSurfaceVariant,
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '日帰り旅行におすすめ！静岡6,000円バスツアーなど',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'まもなく終了！夏の大セールキャンペーン開催中！',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.star_border,
              color: context.outlineVariant,
            ),
          ),
        ],
      ),
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
