<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TaskNote;
use Illuminate\Http\Request;

class TaskNoteController extends Controller
{
    public function index()
    {
        return TaskNote::where('user_id', auth('api')->id())->get();
    }


    public function store(Request $request)
    {
        $request->validate([
            'todo_id' => 'required|exists:todos,id',
            'note' => 'required|string',
        ]);

        $taskNote = TaskNote::create([
            'todo_id' => $request->todo_id,
            'note' => $request->note,
            'user_id' => auth('api')->id(), // ✅ tambah ini
        ]);

        return response()->json([
            'message' => 'Catatan tugas berhasil ditambahkan.',
            'data' => $taskNote
        ], 201);
    }


    public function show($id)
    {
        $taskNote = TaskNote::find($id);
        if (!$taskNote) return response()->json(['message' => 'Catatan tidak ditemukan.'], 404);
        return response()->json($taskNote);
    }

    public function update(Request $request, $id)
    {
        $taskNote = TaskNote::find($id);
        if (!$taskNote) return response()->json(['message' => 'Catatan tidak ditemukan.'], 404);

        $taskNote->update($request->only(['note']));
        return response()->json(['message' => 'Catatan diperbarui.', 'data' => $taskNote]);
    }

    public function destroy($id)
    {
        $taskNote = TaskNote::find($id);
        if (!$taskNote) return response()->json(['message' => 'Catatan tidak ditemukan.'], 404);

        $taskNote->delete();
        return response()->json(['message' => 'Catatan berhasil dihapus.']);
    }
}
