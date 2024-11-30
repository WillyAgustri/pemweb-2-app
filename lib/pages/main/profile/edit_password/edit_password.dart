import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPasswordPage extends StatefulWidget {
  final bool? isPasswordValid;

  const EditPasswordPage({super.key, required this.isPasswordValid});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  Future<void> _updateProfilePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = _auth.currentUser;

    if (user != null) {
      try {
        String newPassword = _passwordController.text.trim();

        await user.updatePassword(newPassword);

        if (mounted) {
          AnimatedSnackBar.material('Profil berhasil diupdate',
                  borderRadius: BorderRadius.circular(50),
                  type: AnimatedSnackBarType.success,
                  snackBarStrategy: RemoveSnackBarStrategy(),
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(seconds: 5),
                  animationCurve: Curves.easeInOut)
              .show(context);

          context.pop();
        }
      } catch (e) {
        if (mounted) {
          AnimatedSnackBar.material('Update password Gagal',
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
    if (!widget.isPasswordValid!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.settings.name != '/') {
          context.go('/');
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    User? user = _auth.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.settings.name != '/login') {
          context.go('/login');
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Ubah Password'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Pastikan password baru anda memenuhi syarat dibawah:\n'
                    '- Minimal terdiri dari 8 karakter\n'
                    '- Mengandung minimal 1 huruf kecil\n'
                    '- Mengandung minimal 1 angka (0, 1, 2, dll)\n'
                    '- Mengandung minimal 1 karakter unik (!, @, #, dll)\n',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscure,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 50),
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 50),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length <= 8) {
                          return 'Minimal 8 karakter';
                        }
                        if (value != value.trim()) {
                          return 'Tidak boleh diawali atau diakhiri spasi';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Harus mengandung huruf kecil';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Harus mengandung angka';
                        }
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Harus mengandung karakter khusus (!, @, #, dll)';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordObscure,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 50),
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 50),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordObscure =
                                  !_isConfirmPasswordObscure;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password konfirmasi tidak boleh kosong';
                        }
                        if (value != _passwordController.text.trim()) {
                          return 'Password konfirmasi berbeda';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProfilePassword,
                      child: const Text(
                        'Simpan Perubahan Password',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
