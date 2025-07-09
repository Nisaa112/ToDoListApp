import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/model/catatanPikiran_model.dart';
import 'package:to_do_list_app/model/difficulty_model.dart';
import 'package:to_do_list_app/model/kategori_user_mode.dart';
import 'package:to_do_list_app/model/label_model.dart';
import 'package:to_do_list_app/model/lampiranTugas_model.dart';
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/model/tugas_sampingan_model.dart';
import 'package:to_do_list_app/utils/token_storage.dart';
import '../model/kategori_model.dart';
import 'package:to_do_list_app/model/catatanTugas_model.dart' as catatan;
import 'package:to_do_list_app/model/user_model.dart' as pengguna;
import 'package:to_do_list_app/model/ulangiTugas_model.dart' as ulangi;
import 'package:to_do_list_app/model/lampiranPikiran_model.dart' as lampiranp;

class ApiService {
  static const String baseUrl = 'https://cockatoo-electric-unduly.ngrok-free.app/';

  static Future<List<KategoriModel>> fetchKategori() async {
    final token = await TokenStorage.getToken(); // Ambil token dulu
    final response = await http.get(
      Uri.parse('${baseUrl}api/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Response status kategori: ${response.statusCode}');
    print('📥 Response body kategori: ${response.body}');

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
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/todos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📦 Status Code: ${response.statusCode}');
    print('📦 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // ✅ Pastikan ini list
      if (decoded is List) {
        return decoded.map((json) => TugasModel.fromJson(json)).toList();
      } else {
        throw Exception('Format data tugas tidak sesuai (bukan List)');
      }
    } else {
      throw Exception('Gagal mengambil data tugas');
    }
  }

  // Tambah tugas baru ke API
  static Future<TugasModel?> createTugas(TugasModel tugas) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/todos'),
      headers: {
        'Authorization': 'Bearer ${await TokenStorage.getToken()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        },
      body: jsonEncode(tugas.toJson()),
    );

    print("📥 Response Create Tugas: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 201) {
    final body = jsonDecode(response.body);
    return TugasModel.fromJson(body);
    } else {
      throw Exception('Gagal menambahkan tugas');
    }
  }

  // Update tugas berdasarkan ID (pastikan ada ID-nya)
  static Future<void> updateTugas(int id, TugasModel tugas) async {
    final response = await http.put(
      Uri.parse('${baseUrl}api/todos/$id'),
      headers: {
        'Authorization': 'Bearer ${await TokenStorage.getToken()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        },
      body: jsonEncode(tugas.toJson()),
    );

    print("📤 Response Update Tugas: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate tugas');
    }
  }

  // Hapus tugas berdasarkan ID
  static Future<void> deleteTugas(int id) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}api/todos/$id'),
      headers: {
        'Authorization': 'Bearer ${await TokenStorage.getToken()}',
        'Accept': 'application/json',
      }
    );

    print("🗑️ Response Delete Tugas: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas');
    }
  }

  // CRUD tugas sampingan
  static Future<List<Data>> fetchTugasSampingan() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/sub-tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Data.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil tugas sampingan');
    }
  }

  static Future<Data?> createTugasSampingan(Data data) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/sub-tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? Data.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal menambah tugas sampingan');
    }
  }

  static Future<void> updateTugasSampingan(Data data) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/sub-tasks/${data.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update tugas sampingan');
    }
  }

  static Future<void> deleteTugasSampingan(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/sub-tasks/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal hapus tugas sampingan');
    }
  }


  // CRUD LABEL
  // 🔁 Fetch semua label
  static Future<List<LabelModel>> fetchLabel() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/labels'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print("📥 Response status label: ${response.statusCode}");
    print("📥 Response body label: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      print("📦 Decoded label type: ${decoded.runtimeType}");
      print("📦 Decoded label content: $decoded");

      // Coba periksa apakah isinya map atau list
      try {
        return List<LabelModel>.from(
          decoded.map((x) => LabelModel.fromJson(x)),
        );
      } catch (e) {
        print("❌ Error saat parsing label: $e");
        throw Exception("Format response label tidak sesuai");
      }
    } else {
      throw Exception('Gagal mengambil label dari API');
    }
  }

  // tambah data label
  static Future<LabelModel?> createLabel(LabelModel label) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('${baseUrl}api/labels'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(label.toJson()),
    );

    print("📤 Request body: ${jsonEncode(label.toJson())}");
    print("📥 Response body: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return LabelModel.fromJson(decoded);
    } else {
      throw Exception('Gagal menambah label');
    }
  }


  // ✏️ Update label
  static Future<void> updateLabel(LabelModel label) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/labels/${label.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': label.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate label');
    }
  }

  // ❌ Hapus label
  static Future<void> deleteLabel(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/labels/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus label');
    }
  }

  static Future<pengguna.Data?> fetchUser() async {
    final token = await TokenStorage.getToken();
    print("🔑 Token dipakai: $token");

    final response = await http.get(
      Uri.parse('${baseUrl}api/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print("📥 USER status: ${response.statusCode}");
    print("📥 USER body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final userModel = pengguna.UserModel.fromJson(decoded);

      if (userModel.data != null && userModel.data!.isNotEmpty) {
        return userModel.data!.first; // Ambil user pertama
      } else {
        print("❌ Data user kosong.");
        return null;
      }
    }

    throw Exception('Gagal mengambil user');
  }

  static Future<pengguna.Data?> createUser(pengguna.Data user) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'photo_profile': user.photoProfile,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? pengguna.Data.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal membuat user');
    }
  }

  static Future<void> updateUser(pengguna.Data user) async {
    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse('${baseUrl}api/users/${user.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'photo_profile': user.photoProfile, // ✅ tambahkan ini
      }),
    );

    print("🧾 Response: ${response.statusCode} | ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate user: ${response.body}');
    }
  }

  static Future<void> deleteUser(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus user');
    }
  }

  // Ambil semua difficulty
  static Future<List<DifficultyModel>> fetchDifficulty() async {
    final response = await http.get(Uri.parse('${baseUrl}api/difficulties'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DifficultyModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil difficulty');
    }
  }

  // Tambah difficulty
  static Future<DifficultyModel?> createDifficulty(DifficultyModel difficulty) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/difficulties'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(difficulty.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? DifficultyModel.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal menambah difficulty');
    }
  }

  // Update difficulty
  static Future<void> updateDifficulty(DifficultyModel difficulty) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/difficulties/${difficulty.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': difficulty.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate difficulty');
    }
  }

  // Hapus difficulty
  static Future<void> deleteDifficulty(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/difficulties/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus difficulty');
    }
  }

  // Kategori user
  static Future<List<KategoriUserModel>> fetchKategoriUser() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/kategori-user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => KategoriUserModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil kategori user');
    }
  }

  static Future<KategoriUserModel?> createKategoriUser(KategoriUserModel kategori) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/kategori-user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(kategori.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? KategoriUserModel.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal menambah kategori user');
    }
  }

  static Future<void> updateKategoriUser(KategoriUserModel kategori) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/kategori-user/${kategori.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': kategori.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update kategori user');
    }
  }

  static Future<void> deleteKategoriUser(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/kategori-user/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal hapus kategori user');
    }
  }

  // catatan pikiran
  static Future<List<CatatanPikiranModel>> fetchCatatanPikiran() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/catatan-pikiran'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CatatanPikiranModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil catatan pikiran');
    }
  }

  static Future<CatatanPikiranModel?> createCatatanPikiran(CatatanPikiranModel catatan) async {
    final token = await TokenStorage.getToken();

    print("📤 Kirim Catatan Pikiran");
    print("🔑 Token: $token");
    print("📌 Payload: ${jsonEncode(catatan.toJson())}");

    final response = await http.post(
      Uri.parse('${baseUrl}api/catatan-pikiran'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(catatan.toJson()),
    );

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? CatatanPikiranModel.fromJson(decoded['data']) : null;
    } else {
      print("❌ Gagal menyimpan catatan pikiran");
      return null;
    }
  }


  static Future<void> updateCatatanPikiran(CatatanPikiranModel catatan) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/catatan-pikiran/${catatan.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'judul': catatan.judul,
        'isi': catatan.isi,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate catatan pikiran');
    }
  }

  static Future<void> deleteCatatanPikiran(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/catatan-pikiran/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus catatan pikiran');
    }
  }

  // ulangi tugas
  static Future<List<ulangi.Data>> fetchUlangiTugas() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/ulangi-tugas'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ulangi.Data.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data ulangi tugas');
    }
  }

  static Future<ulangi.Data?> createUlangiTugas(ulangi.Data data) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/ulangi-tugas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? ulangi.Data.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal menambah data ulangi tugas');
    }
  }

  static Future<void> updateUlangiTugas(ulangi.Data data) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/ulangi-tugas/${data.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update ulangi tugas');
    }
  }

  static Future<void> deleteUlangiTugas(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/ulangi-tugas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal hapus ulangi tugas');
    }
  }

  // CRUD lampiran tugas
  static Future<List<LampiranTugasModel>> fetchLampiranTugas() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/lampiran-tugas'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => LampiranTugasModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil lampiran tugas');
    }
  }

  static Future<LampiranTugasModel?> createLampiranTugas(LampiranTugasModel lampiran) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/lampiran-tugas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(lampiran.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? LampiranTugasModel.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal menambah lampiran tugas');
    }
  }

  static Future<void> updateLampiranTugas(LampiranTugasModel lampiran) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/lampiran-tugas/${lampiran.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(lampiran.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update lampiran tugas');
    }
  }

  static Future<void> deleteLampiranTugas(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/lampiran-tugas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus lampiran tugas');
    }
  }

  // CRUD lampiran pikiran
  static Future<List<lampiranp.Data>> fetchLampiranPikiran() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/lampiran-pikiran'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => lampiranp.Data.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil lampiran pikiran');
    }
  }

  static Future<lampiranp.Data?> createLampiranPikiran(lampiranp.Data lampiran) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/lampiran-pikiran'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(lampiran.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? lampiranp.Data.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal menambah lampiran pikiran');
    }
  }

  static Future<void> updateLampiranPikiran(lampiranp.Data lampiran) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/lampiran-pikiran/${lampiran.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(lampiran.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update lampiran pikiran');
    }
  }

  static Future<void> deleteLampiranPikiran(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/lampiran-pikiran/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus lampiran pikiran');
    }
  }
  // CRUD catatan tugas
  static Future<List<catatan.Data>> fetchCatatanTugas() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}api/catatan-tugas'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => catatan.Data.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil catatan tugas');
    }
  }

  static Future<catatan.Data?> createCatatanTugas(catatan.Data catatanBaru) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}api/catatan-tugas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(catatanBaru.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] != null ? catatan.Data.fromJson(decoded['data']) : null;
    } else {
      throw Exception('Gagal membuat catatan tugas');
    }
  }

  static Future<void> updateCatatanTugas(catatan.Data catatan) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}api/catatan-tugas/${catatan.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(catatan.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update catatan tugas');
    }
  }

  static Future<void> deleteCatatanTugas(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}api/catatan-tugas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus catatan tugas');
    }
  }

  // Di dalam class ApiService
  static Future<bool> uploadPhotoProfile(File imageFile) async {
    final token = await TokenStorage.getToken();

    final uri = Uri.parse('${baseUrl}api/update-profile-picture');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print("✅ Foto profil berhasil diupload");
      return true;
    } else {
      print("❌ Gagal upload foto profil: ${response.statusCode}");
      return false;
    }
  }

}
