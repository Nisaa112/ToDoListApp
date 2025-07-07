<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Note;
use Illuminate\Support\Facades\Validator;

class NotesController extends Controller
{
    // 🔹 Menampilkan semua catatan
    public function index()
    {
        return response()->json(Note::all());
    }

    // 🔹 Menyimpan catatan baru
    public function store(Request $request)
{
    // Ambil langsung isi JSON dari body
    $data = json_decode($request->getContent(), true);

    // Cek kalau parsing gagal
    if (!$data || !isset($data['title'])) {
        return response()->json([
            'message' => 'Data tidak valid atau title kosong.',
            'data_received' => $data
        ], 422);
    }

    // Validasi manual karena kita pakai $data, bukan $request
    $validator = Validator::make($data, [
        'title' => 'required|string|max:255',
        'notes' => 'nullable|string',
        'images' => 'nullable|string',
        'file' => 'nullable|string',
        'user_id' => 'nullable',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'message' => 'Validasi gagal.',
            'errors' => $validator->errors()
        ], 422);
    }

    // Simpan ke database
    $note = Note::create($data);

    return response()->json([
        'message' => 'Catatan berhasil ditambahkan.',
        'data' => $note
    ], 201);
}

    // 🔹 Menampilkan satu catatan
    public function show($id)
    {
        $note = Note::find($id);

        if (!$note) {
            return response()->json(['message' => 'Catatan tidak ditemukan.'], 404);
        }

        return response()->json($note);
    }

    // 🔹 Update catatan
    public function update(Request $request, $id)
    {
        $note = Note::find($id);

        if (!$note) {
            return response()->json(['message' => 'Catatan tidak ditemukan.'], 404);
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'notes' => 'nullable|string',
            'images' => 'nullable|string',
            'file' => 'nullable|string',
            'user_id' => 'nullable|exists:users,id',
        ]);

        $note->update($request->all());

        return response()->json([
            'message' => 'Catatan berhasil diperbarui.',
            'data' => $note
        ]);
    }

    // 🔹 Hapus catatan
    public function destroy($id)
    {
        $note = Note::find($id);

        if (!$note) {
            return response()->json(['message' => 'Catatan tidak ditemukan.'], 404);
        }

        $note->delete();

        return response()->json(['message' => 'Catatan berhasil dihapus.']);
    }
}
