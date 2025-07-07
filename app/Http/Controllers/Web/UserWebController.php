<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Exception;

class UserWebController extends Controller
{
    // Tampilkan halaman form create
    public function create()
    {
        return view('user_page.create');
    }

    // Simpan data user baru
    public function store(Request $request)
    {
        try {
            // Validasi input
            $request->validate([
                'name'           => 'required|string|max:255',
                'email'          => 'required|email|unique:users,email',
                'photo_profile'  => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
            ]);

            // Upload foto jika ada
            $photoPath = null;
            if ($request->hasFile('photo_profile')) {
                $photoPath = $request->file('photo_profile')->store('photos', 'public');
            }

            // Simpan user ke database
            User::create([
                'name'           => $request->name,
                'email'          => $request->email,
                'photo_profile'  => $photoPath,
            ]);

            return redirect()->back()->with('success', 'User berhasil ditambahkan.');
        } catch (Exception $e) {
            // Tangani jika gagal
            return redirect()->back()->with('error', 'Gagal menambahkan user: ' . $e->getMessage());
        }
    }
}
