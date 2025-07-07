<?php 

namespace App\Http\Controllers;

use App\Models\AuthSerialNumber;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthSerialNumberController extends Controller
{
    public function index()
    {
        return AuthSerialNumber::with('user')->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'serial_number' => 'required|string|max:255|unique:auth_serial_numbers',
            'password' => 'required|string|min:6',
        ]);

        AuthSerialNumber::create([
            'user_id' => $request->user_id,
            'serial_number' => $request->serial_number,
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'message' => 'Serial number created successfully',
            'serial_number' => $request->serial_number,
        ], 201);
    }

    public function show($id)
    {
        return AuthSerialNumber::with('user')->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $serial = AuthSerialNumber::findOrFail($id);

        $validated = $request->validate([
            'user_id' => 'sometimes|exists:users,id',
            'serial_number' => 'sometimes|string|max:255',
        ]);

        $serial->update($validated);

        return response()->json($serial);
    }

    public function destroy($id)
    {
        $serial = AuthSerialNumber::findOrFail($id);
        $serial->delete();

        return response()->json(['message' => 'Deleted successfully']);
    }
}

