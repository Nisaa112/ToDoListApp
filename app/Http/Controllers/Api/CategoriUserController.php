<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\CategoriUser;

class CategoriUserController extends Controller
{
    public function index()
    {
        $kategori = CategoriUser::all();
        return response()->json($kategori);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'user_id' => 'required|exists:users,id',
        ]);

        $kategori = CategoriUser::create([
            'name' => $request->name,
            'user_id' => $request->user_id,
        ]);

        return response()->json([
            'message' => 'Kategori berhasil dibuat.',
            'data' => $kategori,
        ], 201);
    }

    public function show($id)
    {
        $kategori = CategoriUser::find($id);

        if (!$kategori) {
            return response()->json(['message' => 'Kategori tidak ditemukan.'], 404);
        }

        return response()->json($kategori);
    }

    public function update(Request $request, $id)
    {
        $kategori = CategoriUser::find($id);

        if (!$kategori) {
            return response()->json(['message' => 'Kategori tidak ditemukan.'], 404);
        }

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'user_id' => 'sometimes|exists:users,id',
        ]);

        $kategori->update($request->only(['name', 'user_id']));

        return response()->json([
            'message' => 'Kategori berhasil diperbarui.',
            'data' => $kategori,
        ]);
    }

    public function destroy($id)
    {
        $kategori = CategoriUser::find($id);

        if (!$kategori) {
            return response()->json(['message' => 'Kategori tidak ditemukan.'], 404);
        }

        $kategori->delete();

        return response()->json(['message' => 'Kategori berhasil dihapus.']);
    }
}
