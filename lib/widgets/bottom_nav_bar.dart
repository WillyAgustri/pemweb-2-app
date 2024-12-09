import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentSelectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavBar({
    super.key,
    required this.currentSelectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.settings.name != '/login') {
          context.go('/login');
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    String getInitials(String name) {
      List<String> words = name.trim().split(RegExp(r'\s+'));
      String initials =
          words.take(2).map((word) => word[0].toUpperCase()).join();

      return initials;
    }

    return NavigationBar(
      height: 65,
      indicatorShape: const CircleBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (index) {
        onDestinationSelected(index);
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/explore');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
      indicatorColor: Colors.blue,
      selectedIndex: currentSelectedIndex,
      destinations: <Widget>[
        const NavigationDestination(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        const NavigationDestination(
          icon: Icon(Icons.search_rounded),
          label: 'Jelajah'
        ),
        NavigationDestination(
          icon: CircleAvatar(
            radius: 12,
            backgroundImage:
                user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL != null
                ? null
                : Stack(
                    children: [
                      Text(
                        user.displayName != null
                            ? getInitials(user.displayName!)
                            : 'N/A',
                        style: const TextStyle(fontSize: 7),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
