<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Lampiran;
use Illuminate\Support\Facades\Storage;

class LampiranController extends Controller
{
    public function index()
    {
        return response()->json(Lampiran::all());
    }

    public function show($id)
    {
        $lampiran = Lampiran::find($id);

        if (!$lampiran) {
            return response()->json(['message' => 'Lampiran tidak ditemukan'], 404);
        }

        return response()->json($lampiran);
    }

    public function store(Request $request)
    {
        $request->validate([
            'todo_id' => 'required|exists:todos,id',
            'file' => 'required|file|mimes:jpg,png,pdf|max:2048',
        ]);

        $file = $request->file('file');
        $filePath = $file->store('lampiran', 'public'); // simpan di storage/app/public/lampiran
        $fileType = $file->getMimeType();

        $lampiran = \App\Models\Lampiran::create([
            'todo_id' => $request->todo_id,
            'user_id' => auth('api')->id(), // ✅ tambahkan ini
            'file_path' => $filePath,
            'file_type' => $fileType,
        ]);

        return response()->json([
            'message' => 'Lampiran berhasil disimpan.',
            'data' => $lampiran,
        ]);
    }


    public function update(Request $request, $id)
    {
        $lampiran = Lampiran::find($id);

        if (!$lampiran) {
            return response()->json(['message' => 'Lampiran tidak ditemukan'], 404);
        }

        $request->validate([
            'file' => 'nullable|file|max:2048',
        ]);

        if ($request->hasFile('file')) {
            // Hapus file lama
            Storage::disk('public')->delete($lampiran->file_path);

            // Simpan file baru
            $path = $request->file('file')->store('lampiran', 'public');
            $lampiran->file_path = $path;
            $lampiran->file_type = $request->file('file')->getClientMimeType();
        }

        $lampiran->save();

        return response()->json($lampiran);
    }

    public function destroy($id)
    {
        $lampiran = Lampiran::find($id);

        if (!$lampiran) {
            return response()->json(['message' => 'Lampiran tidak ditemukan'], 404);
        }

        // Hapus file dari storage
        Storage::disk('public')->delete($lampiran->file_path);

        $lampiran->delete();

        return response()->json(['message' => 'Lampiran berhasil dihapus']);
    }
}
