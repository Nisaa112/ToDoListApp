<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AuthSerialNumber;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthSerialNumberWebController extends Controller
{
    public function create()
    {
        $users = User::all();
        return view('serial.create', compact('users'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id'       => 'required|exists:users,id',
            'serial_number' => 'required|string|unique:auth_serial_numbers,serial_number',
            'password'      => 'required|string|min:6',
        ]);

        AuthSerialNumber::create([
            'user_id'       => $request->user_id,
            'serial_number' => $request->serial_number,
            'password'      => Hash::make($request->password),
        ]);

        return redirect()->back()->with('success', 'Serial Number berhasil ditambahkan.');
    }
}
