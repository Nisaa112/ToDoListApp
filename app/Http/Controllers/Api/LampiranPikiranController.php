<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\LampiranPikiran;

class LampiranPikiranController extends Controller
{
    public function index()
    {
        $lampiran = LampiranPikiran::where('user_id', auth('api')->id())->get();

        return response()->json([
            'message' => 'Data lampiran berhasil diambil',
            'data' => $lampiran
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'catatan_pikiran_id' => 'required|exists:catatan_pikiran,id',
            'file' => 'required|file|max:2048'
        ]);

        $path = $request->file('file')->store('lampiran_pikiran', 'public');

        $lampiran = LampiranPikiran::create([
            'user_id' => auth('api')->id(),
            'catatan_pikiran_id' => $request->catatan_pikiran_id,
            'file_path' => $path,
            'file_type' => $request->file('file')->getClientMimeType(),
        ]);

        return response()->json([
            'message' => 'Lampiran berhasil disimpan',
            'data' => $lampiran
        ], 201);
    }

    public function show($id)
    {
        $lampiran = LampiranPikiran::where('id', $id)
            ->where('user_id', auth('api')->id())
            ->first();

        if (!$lampiran) {
            return response()->json(['message' => 'Lampiran tidak ditemukan'], 404);
        }

        return response()->json(['data' => $lampiran]);
    }

    public function update(Request $request, $id)
    {
        $lampiran = LampiranPikiran::where('id', $id)
            ->where('user_id', auth('api')->id())
            ->first();

        if (!$lampiran) {
            return response()->json(['message' => 'Lampiran tidak ditemukan'], 404);
        }

        $request->validate([
            'catatan_pikiran_id' => 'sometimes|exists:catatan_pikiran,id',
            'file' => 'sometimes|file|max:2048',
        ]);

        if ($request->hasFile('file')) {
            // Hapus file lama
            Storage::disk('public')->delete($lampiran->file_path);
            // Upload file baru
            $path = $request->file('file')->store('lampiran_pikiran', 'public');
            $lampiran->file_path = $path;
            $lampiran->file_type = $request->file('file')->getClientMimeType();
        }

        if ($request->has('catatan_pikiran_id')) {
            $lampiran->catatan_pikiran_id = $request->catatan_pikiran_id;
        }

        $lampiran->save();

        return response()->json([
            'message' => 'Lampiran berhasil diperbarui',
            'data' => $lampiran
        ]);
    }

    public function destroy($id)
    {
        $lampiran = LampiranPikiran::where('id', $id)
            ->where('user_id', auth('api')->id())
            ->first();

        if (!$lampiran) {
            return response()->json(['message' => 'Lampiran tidak ditemukan'], 404);
        }

        Storage::disk('public')->delete($lampiran->file_path);
        $lampiran->delete();

        return response()->json(['message' => 'Lampiran berhasil dihapus']);
    }
}
