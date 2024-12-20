import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  Future<void> _loginWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        AnimatedSnackBar.material('Login Berhasil',
                borderRadius: BorderRadius.circular(50),
                snackBarStrategy: RemoveSnackBarStrategy(),
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);

        User? user = FirebaseAuth.instance.currentUser;

        if (user?.displayName != null) {
          context.go('/');
        } else {
          context.go('/edit-profile/new-user', extra: {'nextRoute': '/'});
        }
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.material(
                'Login Gagal, periksa kembali email dan password anda',
                snackBarStrategy: RemoveSnackBarStrategy(),
                borderRadius: BorderRadius.circular(50),
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    String? googleClientID = dotenv.env['GOOGLE_CLIENT_ID'];

    try {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(clientId: googleClientID, scopes: <String>['email']);

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _auth.signInWithCredential(credential);
      if (mounted) {
        AnimatedSnackBar.material('Login Berhasil',
                borderRadius: BorderRadius.circular(50),
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(seconds: 5),
                animationCurve: Curves.easeInOut)
            .show(context);
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.material('Login dengan Google Gagal',
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 36, 36, 36),
                child: Column(children: [
                  const SizedBox(
                    height: 36,
                    width: double.infinity,
                    // child: ColoredBox(color: Colors.transparent),
                  ),
                  Image.asset(
                    'assets/logo_main_text.png',
                    width: 66,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      prefixIconConstraints: const BoxConstraints(minWidth: 50),
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIconConstraints: const BoxConstraints(minWidth: 50),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Lupa password anda? ',
                        style: TextStyle(fontSize: 12),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () => context.push('/reset-password'),
                        child: const Text('Reset Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginWithEmailPassword,
                        child: const Text(
                          'Login dengan Email',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _loginWithGoogle,
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(5),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white70),
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromRGBO(20, 20, 20, 1))),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/google.png'),
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Login dengan Google',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ])),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () => context.push('/signup'),
                        child: const Text('Daftar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                ])),
          ),
        ),
      ]),
    ));
  }
}
