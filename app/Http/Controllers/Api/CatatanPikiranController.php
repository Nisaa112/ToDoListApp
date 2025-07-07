<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\CatatanPikiran;

class CatatanPikiranController extends Controller
{
    public function index()
    {
        return response()->json(CatatanPikiran::all());
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'judul' => 'nullable|string',
            'isi' => 'nullable|string',
        ]);

        $catatan = CatatanPikiran::create($validated);
        return response()->json($catatan, 201);
    }

    public function show($id)
    {
        $catatan = CatatanPikiran::find($id);
        if (!$catatan) {
            return response()->json(['message' => 'Catatan tidak ditemukan'], 404);
        }

        return response()->json($catatan);
    }

    public function update(Request $request, $id)
    {
        $catatan = CatatanPikiran::find($id);
        if (!$catatan) {
            return response()->json(['message' => 'Catatan tidak ditemukan'], 404);
        }

        $validated = $request->validate([
            'judul' => 'nullable|string',
            'isi' => 'nullable|string',
        ]);

        $catatan->update($validated);
        return response()->json($catatan);
    }

    public function destroy($id)
    {
        $catatan = CatatanPikiran::find($id);
        if (!$catatan) {
            return response()->json(['message' => 'Catatan tidak ditemukan'], 404);
        }

        $catatan->delete();
        return response()->json(['message' => 'Catatan berhasil dihapus']);
    }
}
