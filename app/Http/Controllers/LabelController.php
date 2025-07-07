<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Label;

class LabelController extends Controller
{
    public function index()
    {
        // Menampilkan semua label milik user yang login
        $labels = Label::where('user_id', auth('api')->id())->get();
        return response()->json($labels);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255'
        ]);

        $label = Label::create([
            'name' => $request->name,
            'user_id' => auth('api')->id()
        ]);

        return response()->json($label, 201);
    }

    public function show($id)
    {
        $label = Label::where('id', $id)->where('user_id', auth('api')->id())->first();

        if (!$label) {
            return response()->json(['message' => 'Label tidak ditemukan'], 404);
        }

        return response()->json($label);
    }

    public function update(Request $request, $id)
    {
        $label = Label::where('id', $id)->where('user_id', auth('api')->id())->first();

        if (!$label) {
            return response()->json(['message' => 'Label tidak ditemukan'], 404);
        }

        $request->validate([
            'name' => 'required|string|max:255'
        ]);

        $label->name = $request->name;
        $label->save();

        return response()->json(['message' => 'Label berhasil diperbarui', 'data' => $label]);
    }

    public function destroy($id)
    {
        $label = Label::where('id', $id)
            ->where('user_id', \Illuminate\Support\Facades\Auth::id())

            ->first();

        if (!$label) {
            return response()->json(['message' => 'Label tidak ditemukan'], 404);
        }

        $label->delete();

        return response()->json(['message' => 'Label berhasil dihapus'], 200);
    }
}
