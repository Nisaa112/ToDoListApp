<?php

namespace App\Http\Controllers\Api;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    // 🔍 GET /api/users
    public function index()
    {
        $users = User::all();
        return response()->json([
            'message' => 'Daftar user berhasil diambil.',
            'data' => $users
        ], 200);
    }

    // 🔎 GET /api/users/{id}
    public function show($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan.'], 404);
        }

        return response()->json([
            'message' => 'Detail user berhasil diambil.',
            'data' => $user
        ], 200);
    }

    // ➕ POST /api/users
   public function store(Request $request)
{
    $request->validate([
        'name'           => 'required|string|max:255',
        'email'          => 'required|email|unique:users,email',
        'password'       => 'required|string|min:6',
        'photo_profile'  => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
    ]);

    $photoPath = null;
    if ($request->hasFile('photo_profile')) {
        $photoPath = $request->file('photo_profile')->store('photos', 'public');
    }

    $user = User::create([
        'name'           => $request->name,
        'email'          => $request->email,
        'password'       => Hash::make($request->password),
        'photo_profile'  => $photoPath,
    ]);

    return response()->json([
        'message' => 'User berhasil ditambahkan.',
        'data'    => $user,
        'photo_profile_url' => $photoPath ? asset('storage/' . $photoPath) : null,
    ], 201);
}

    // ✏️ PUT /api/users/{id}
    public function update(Request $request, $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan.'], 404);
        }

        $request->validate([
            'name'     => 'nullable|string|max:255',
            'email'    => 'nullable|email|unique:users,email,' . $id,
            'password' => 'nullable|string|min:6'
        ]);

        if ($request->name) $user->name = $request->name;
        if ($request->email) $user->email = $request->email;
        if ($request->password) $user->password = Hash::make($request->password);

        $user->save();

        return response()->json([
            'message' => 'User berhasil diperbarui.',
            'data' => $user
        ], 200);
    }

    // ❌ DELETE /api/users/{id}
    public function destroy($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan.'], 404);
        }

        $user->delete();

        return response()->json(['message' => 'User berhasil dihapus.'], 200);
    }
}
