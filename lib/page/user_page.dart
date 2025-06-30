import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: Color(0xFF485F88),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.check, color: Color.fromRGBO(238, 241, 248, 1.0), size: 30),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        title: Text(
          "Pengguna",
          style: TextStyle(
            color: Color.fromRGBO(238, 241, 248, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: 0,
            child: Container(
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 241, 248, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf2hQMkanNHRB00g7rFrCm4gfpNdLvV2MUPg&s',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Ganti Foto Profil", style: TextStyle(color: Colors.blueGrey)),
                  ),

                  // Form Fields
                  buildInputField("Nama Pengguna", "Ganti Nama Pengguna..."),
                  buildInputField("Nama", "Ganti Nama..."),
                  buildInputField("Email", "Ganti Email..."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildInputField(String label, String hint) {
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey),
            filled: true,
            fillColor: Color.fromRGBO(238, 241, 248, 1.0),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF485F88)),
            ),
          ),
        ),
      ],
    ),
  );
}
