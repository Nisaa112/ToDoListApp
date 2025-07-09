import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/auth_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/user_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF485F88),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: keyboardVisible ? 30 : 150,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/img/logo1.png',
                  color: Colors.white,
                  width: 115,
                  height: 115,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: keyboardVisible ? 220 : 400,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(238, 241, 248, 1.0),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF485F88),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text("Serial Number", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _serialController,
                        decoration: InputDecoration(
                          hintText: "Masukan Serial Number",
                          hintStyle: const TextStyle(color: Colors.blueGrey),
                          filled: true,
                          fillColor: Color.fromRGBO(238, 241, 248, 1.0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Masukan Password",
                          hintStyle: const TextStyle(color: Colors.blueGrey),
                          filled: true,
                          fillColor: Color.fromRGBO(238, 241, 248, 1.0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF485F88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final authVM = Provider.of<AuthViewModel>(context, listen: false);
                            final userVM = Provider.of<UserViewModel>(context, listen: false);

                            final success = await authVM.login(
                              _serialController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (!mounted) return;

                            if (success) {
                              final userVM = Provider.of<UserViewModel>(context, listen: false);
                              await userVM.fetchUser();

                              Navigator.pushReplacementNamed(context, '/home');
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(authVM.errorMessage ?? "Login gagal")),
                              );
                            }
                          },
                          child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 17)),
                        ),
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
