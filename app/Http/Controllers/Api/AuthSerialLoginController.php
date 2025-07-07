<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\AuthSerialNumber;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthSerialLoginController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'serial_number' => 'required',
            'password' => 'required',
        ]);

        $user = AuthSerialNumber::where('serial_number', $request->serial_number)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Serial Number atau Password salah'], 401);
        }

        $token = JWTAuth::fromUser($user);

        return response()->json([
            
            'token' => $token,
            'serial_number' => $user->serial_number,
            'user_id' => $user->user_id,
            'token_type' => 'Bearer',
        ]);
    }
}
