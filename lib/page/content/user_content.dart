import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/viewmodel/user_viewmodel.dart';
import 'package:to_do_list_app/model/user_model.dart' as pengguna;

class UserContent extends StatefulWidget {
  const UserContent({super.key});

  @override
  State<UserContent> createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserViewModel>(context).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });

      try {
        await Provider.of<UserViewModel>(context, listen: false).uploadPhoto(_selectedImage!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Foto profil berhasil diupload.")),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Gagal upload foto profil: $e")),
        );
      }
    }
  }

  void _simpanPerubahan(UserViewModel userVM) async {
    setState(() => _isLoading = true);
    final user = userVM.user;
    if (user == null) return;

    final updatedUser = pengguna.Data(
      id: user.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      createdAt: user.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      photoProfile: user.photoProfile, // Nanti diganti kalau upload berhasil
    );

    try {
      await userVM.updateUser(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Data pengguna berhasil diperbarui")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal memperbarui pengguna: $e")),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userVM, child) {
        final user = userVM.user;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profileUrl = user.photoProfile != null
          ? '${ApiService.baseUrl}/storage/${user.photoProfile!}'
          : 'https://i.pinimg.com/474x/d7/95/c3/d795c373a0539e64c7ee69bb0af3c5c3.jpg';

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF485F88),
          appBar: AppBar(
            backgroundColor: const Color(0xFF485F88),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.check, color: Color(0xFFEEF1F8), size: 30),
              onPressed: () => _simpanPerubahan(userVM),
            ),
            title: const Text(
              "Pengguna",
              style: TextStyle(color: Color(0xFFEEF1F8), fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF1F8),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : NetworkImage(profileUrl) as ImageProvider,
                            ),
                          ),
                        ),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text("Ganti Foto Profil", style: TextStyle(color: Colors.blueGrey)),
                      ),
                      _buildInputField("Nama Pengguna", _nameController),
                      _buildInputField("Email", _emailController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Colors.blueGrey),
              filled: true,
              fillColor: const Color(0xFFEEF1F8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF485F88)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
