import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      if (mounted) {
        AnimatedSnackBar.material('Link reset telah dikirim',
                borderRadius: BorderRadius.circular(50),
                snackBarStrategy: RemoveSnackBarStrategy(),
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);

        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.material('Terjadi kesalahan',
                borderRadius: BorderRadius.circular(50),
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Masukkan email Anda untuk menerima tautan reset password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _sendResetEmail,
                                    child: const Text('Kirim Email Reset'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () => context.pop(),
                                      style: ButtonStyle(
                                        foregroundColor: const WidgetStatePropertyAll(Colors.white60),
                                        backgroundColor: const WidgetStatePropertyAll(Colors.white10),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            side: const BorderSide(
                                              color: Colors.white60,
                                            )
                                          )
                                        )
                                      ),
                                      child: const Text('Kembali'),
                                    ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
