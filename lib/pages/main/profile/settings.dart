import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        AnimatedSnackBar.material('Logout Gagal',
                borderRadius: BorderRadius.circular(50),
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null || user.displayName == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.settings.name != '/login') {
          context.go('/login');
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Text('Selamat datang, ${user.displayName}!',
                style: const TextStyle(fontSize: 24)),
            ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
                onPressed: () {
                  context.push('/edit-profile');
                },
                child: const Text('Edit Profil'))
          ]))),
    );
  }
}
