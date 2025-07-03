import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF485F88),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70),
              child: Image.asset('assets/img/logo1.png', color: Colors.white, width: 115, height: 115,),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 250),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 241, 248, 1.0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50)
                    )
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
                            color: Color(0xFF485F88)
                          )
                        ),
                      ),
                      SizedBox(height: 32,),
                      Text(
                        "Serial Number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _serialController,
                        decoration: InputDecoration(
                          hintText: "Masukan Serial Number",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                          filled: true,
                          fillColor: Color.fromRGBO(238, 241, 248, 1.0),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF485F88),
                            )
                          )
                        ),
                      ),
                      SizedBox(height: 16,),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        // obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Masukan Password",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                          filled: true,
                          fillColor: Color.fromRGBO(238, 241, 248, 1.0),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF485F88),
                              width: 2
                            )
                          )
                        ),
                      ),
                      SizedBox(height: 35,),

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF485F88),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                          onPressed: () async {
                            final authVM = Provider.of<AuthViewModel>(context, listen: false);
                            final success = await authVM.login(
                              _serialController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (success) {
                              Navigator.pushReplacementNamed(context, '/home'); // atau sesuai route kamu
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(authVM.errorMessage ?? "Login gagal")),
                              );
                            }
                          },
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 17)),
                        ),
                      ),
                      SizedBox(height: 16,),

                      Center(
                        child: Text(
                          "Lupa Password",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}