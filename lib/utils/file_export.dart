import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportTxt(String judul, String isi) async {
  // Minta izin penyimpanan
  final status = await Permission.storage.request();
  if (!status.isGranted) return;

  // Ambil direktori eksternal
  final directory = await getExternalStorageDirectory();
  if (directory == null) return;

  final filePath = '${directory.path}/$judul.txt';
  final file = File(filePath);

  // Tulis ke file
  await file.writeAsString('Judul: $judul\n\n$isi');

  print("✅ File berhasil diekspor: $filePath");
}
