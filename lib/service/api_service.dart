import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/utils/token_storage.dart';
import '../model/kategori_model.dart';

class ApiService {
  static const String baseUrl = 'https://cockatoo-electric-unduly.ngrok-free.app/';

  static Future<List<KategoriModel>> fetchKategori() async {
    final response = await http.get(Uri.parse('${baseUrl}api/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => KategoriModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil kategori');
    }
  }

  static Future<KategoriModel?> createKategori(KategoriModel kategori) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(kategori.toJson()),
    );

    print("📤 Response Body: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // ✅ Ambil dari field `data`
      if (decoded['data'] != null) {
        return KategoriModel.fromJson(decoded['data']);
      } else {
        throw Exception('Respons API tidak valid: data tidak ditemukan');
      }
    } else {
      print("❌ Gagal tambah kategori, code: ${response.statusCode}");
      print("🧾 Body: ${response.body}");
      throw Exception('Gagal menambah kategori');
    }
  }

  static Future<void> updateKategori(KategoriModel kategori) async {
    final token = await TokenStorage.getToken();
    final url = '${baseUrl}api/categories/${kategori.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'name': kategori.name}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate kategori');
    }
  }

  static Future<void> deleteKategori(int id) async {
    final token = await TokenStorage.getToken();
    final url = '${baseUrl}api/categories/$id';
    print("🔐 Token: $token");

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print("ME ENDPOINT: ${response.statusCode} - ${response.body}");
    print("🗑️ DELETE Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      return; // ✅ sukses
    } else if (response.statusCode == 404) {
      // ❗ kategori sudah tidak ada di server
      throw Exception("Kategori tidak ditemukan");
    } else {
      throw Exception('Gagal menghapus kategori');
    }
  }

  // Ambil semua tugas dari API
  static Future<List<TugasModel>> fetchTugas() async {
    final response = await http.get(Uri.parse('${baseUrl}api/todos'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TugasModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data tugas');
    }
  }

  // Tambah tugas baru ke API
  static Future<TugasModel?> createTugas(TugasModel tugas) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tugas.toJson()),
    );

    print("📥 Response Create Tugas: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      return TugasModel.fromJson(data);
    } else {
      throw Exception('Gagal menambahkan tugas');
    }
  }

  // Update tugas berdasarkan ID (pastikan ada ID-nya)
  static Future<void> updateTugas(int id, TugasModel tugas) async {
    final response = await http.put(
      Uri.parse('${baseUrl}api/todos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tugas.toJson()),
    );

    print("📤 Response Update Tugas: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate tugas');
    }
  }

  // Hapus tugas berdasarkan ID
  static Future<void> deleteTugas(int id) async {
    final response = await http.delete(Uri.parse('${baseUrl}api/todos/$id'));

    print("🗑️ Response Delete Tugas: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas');
    }
  }

}
