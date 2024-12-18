import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
// import 'package:simple_icons/simple_icons.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  Future<void> _signUpWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        AnimatedSnackBar.material('SignUp Berhasil! Silakan Login',
                borderRadius: BorderRadius.circular(50),
                snackBarStrategy: RemoveSnackBarStrategy(),
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.material('SignUp Gagal!',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              width: double.infinity,
              // child: ColoredBox(color: Colors.transparent),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 0, 36, 36),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Image.asset(
                        'logo_main_text.png',
                        width: 66,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'SignUp',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
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
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: const [AutofillHints.newPassword],
                        decoration: InputDecoration(
                          label: const Text('Password'),
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
                        obscureText: _isPasswordObscure,
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
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          label: const Text('Konfirmasi Password'),
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
                        obscureText: _isConfirmPasswordObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password konfirmasi tidak boleh kosong';
                          }
                          if (value != _passwordController.text.trim()) {
                            return 'Password konfirmasi berbeda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signUpWithEmailPassword,
                            child: const Text(
                              'Signup dengan Email',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            onPressed: () => context.pop(),
                            child: const Text('Masuk',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )),
                          )
                        ],
                      )
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
