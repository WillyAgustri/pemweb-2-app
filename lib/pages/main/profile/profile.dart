import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? username = FirebaseAuth.instance.currentUser?.displayName;

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
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

  void _navigateToEditPasswordPage(BuildContext context, User? user) async {
    return showDialog(
      context: context,
      builder: (context) {
        String password = '';

        return AlertDialog(
          title: const Text(
            'Ganti Password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Masukkan password saat ini untuk lanjut',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ButtonStyle(
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white60),
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.white10),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: Colors.white60,
                            )))),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          String email = user!.email!;

                          AuthCredential credential =
                              EmailAuthProvider.credential(
                            email: email,
                            password: password,
                          );

                          await user.reauthenticateWithCredential(credential);

                          if (context.mounted) {
                            context.pop();
                            context.push('/edit-password',
                                extra: {'isPasswordValid': true});
                          }
                        } catch (e) {
                          if (context.mounted) {
                            AnimatedSnackBar.material('Password salah',
                                    snackBarStrategy: RemoveSnackBarStrategy(),
                                    borderRadius: BorderRadius.circular(50),
                                    type: AnimatedSnackBarType.error,
                                    mobileSnackBarPosition:
                                        MobileSnackBarPosition.top,
                                    duration: const Duration(seconds: 5),
                                    animationCurve: Curves.easeInOut)
                                .show(context);
                          }
                        }
                      }
                    },
                    child: const Text('Lanjutkan'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUsername(_auth.currentUser); // Ambil username saat halaman dibuka
  }

  Future<void> _fetchUsername(User? user) async {
    try {
      if (mounted) {
        if (user != null) {
          setState(() {
            username = user.displayName;
          });
        } else {
          setState(() {
            username = 'User not logged in';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          username = 'Error fetching username';
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchUsername(_auth.currentUser);
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

    bool isPasswordLogin =
        user.providerData.any((provider) => provider.providerId == 'password');
    bool isAccountVerified = user.emailVerified;

    // print(user.photoURL);
    // print(isAccountVerified);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isAccountVerified
                      ? const SizedBox()
                      : Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.blueAccent,
                                  size: 32,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'Akun Belum Terverifikasi'
                                  , style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Saat ini akun anda belum terverifikasi.',
                                  style: TextStyle(fontSize: 12, color: Colors.white54)
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  const Text('Verifikasi akun anda lewat email ', style: TextStyle(fontSize: 12, color: Colors.white54),),
                                  TextButton(
                                    onPressed: () => context.push('/verify-account'),
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(0),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
                                    child: const Text('Di sini', style: TextStyle(fontSize: 11),),
                                  )
                                ]),
                              ],
                            ),
                        ),
                      ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Profil Anda',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: user.photoURL != null
                                  ? NetworkImage(user.photoURL!)
                                  : null,
                              child: user.photoURL != null
                                  ? null
                                  : Stack(
                                      children: [
                                        Text(
                                          user.displayName != null
                                              ? getInitials(user.displayName!)
                                              : 'N/A',
                                          style: const TextStyle(fontSize: 30),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Username',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white54),
                                      ),
                                      Wrap(
                                        spacing: 5,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context).size.width - 113
                                            ),
                                            child: Text(
                                              '${user.displayName}',
                                              maxLines: 1,
                                              textWidthBasis: TextWidthBasis.parent,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          isAccountVerified
                                              ? const Icon(
                                                Icons.verified,
                                                size: 16,
                                                color: Colors.blueAccent,
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white54),
                                      ),
                                      Text(
                                        '${user.email}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () =>
                                      context.push('/edit-profile'),
                                  child: const Text(
                                    'Edit Profil',
                                  )),
                            ),
                            isPasswordLogin
                                ? Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              _navigateToEditPasswordPage(
                                                  context, user);
                                            },
                                            child: const Text(
                                              'Ubah Password',
                                            )),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () => context.push('/about'),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.white60),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.transparent),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(
                                                color: Colors.white54,
                                              )))),
                                  child: const Text(
                                    'Tentang Aplikasi',
                                    style:
                                        TextStyle(color: Colors.white54),
                                  )),
                            ),
                            const SizedBox(height: 8,),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () => _logout(context),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.white60),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.transparent),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                color: Colors.red.shade400,
                                              )))),
                                  child: Text(
                                    'LogOut',
                                    style:
                                        TextStyle(color: Colors.red.shade400),
                                  )),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
