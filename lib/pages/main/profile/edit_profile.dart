import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  final String? nextRoute;
  final bool firstTimeLogin;

  const EditProfilePage(
      {super.key, this.nextRoute, required this.firstTimeLogin});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    if (user != null) {
      _usernameController.text = user.displayName ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = _auth.currentUser;

    if (user != null) {
      try {
        String newUsername = _usernameController.text.trim();

        await user.updateDisplayName(newUsername);

        if (mounted) {
          AnimatedSnackBar.material('Profil berhasil diupdate',
                  borderRadius: BorderRadius.circular(50),
                  type: AnimatedSnackBarType.success,
                  snackBarStrategy: RemoveSnackBarStrategy(),
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(seconds: 5),
                  animationCurve: Curves.easeInOut)
              .show(context);

          widget.nextRoute != null
              ? context.go(widget.nextRoute!)
              : context.pop();
        }
      } catch (e) {
        if (mounted) {
          AnimatedSnackBar.material('Update profil Gagal',
                  borderRadius: BorderRadius.circular(50),
                  snackBarStrategy: RemoveSnackBarStrategy(),
                  type: AnimatedSnackBarType.error,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(seconds: 5),
                  animationCurve: Curves.easeInOut)
              .show(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

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

    return Scaffold(
      appBar: AppBar(
        leading: widget.firstTimeLogin || user.displayName == null
            ? null
            : BackButton(
                onPressed: () => context.pop(),
              ),
        title: const Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
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
                            style: const TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIconConstraints: BoxConstraints(minWidth: 50),
                      prefixIcon: Icon(
                        Icons.person,
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan username';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Simpan Perubahan'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
