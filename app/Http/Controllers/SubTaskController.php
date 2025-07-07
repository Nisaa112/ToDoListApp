<?php

namespace App\Http\Controllers;

use App\Models\SubTask;
use Illuminate\Http\Request;

class SubTaskController extends Controller
{
    public function index()
    {
        // Hanya tampilkan subtask milik user yang login
        $subTasks = SubTask::where('user_id', auth('api')->id())->get();
        return response()->json($subTasks);
    }

    public function store(Request $request)
    {
        $request->validate([
            'todo_id' => 'required|exists:todos,id',
            'title' => 'required|string',
        ]);

        $subTask = SubTask::create([
            'user_id' => auth('api')->id(), // disimpan dari user login
            'todo_id' => $request->todo_id,
            'title' => $request->title,
            'is_done' => $request->is_done ?? false,
        ]);

        return response()->json([
            'message' => 'Subtask berhasil ditambahkan.',
            'data' => $subTask
        ], 201);
    }

    public function show($id)
    {
        $subTask = SubTask::where('id', $id)
                          ->where('user_id', auth('api')->id())
                          ->first();

        if (!$subTask) {
            return response()->json(['message' => 'Subtask tidak ditemukan.'], 404);
        }

        return response()->json($subTask);
    }

    public function update(Request $request, $id)
    {
        $subTask = SubTask::where('id', $id)
                          ->where('user_id', auth('api')->id())
                          ->first();

        if (!$subTask) {
            return response()->json(['message' => 'Subtask tidak ditemukan.'], 404);
        }

        $subTask->update($request->only(['title', 'is_done']));
        return response()->json([
            'message' => 'Subtask diperbarui.',
            'data' => $subTask
        ]);
    }

    public function destroy($id)
    {
        $subTask = SubTask::where('id', $id)
                          ->where('user_id', auth('api')->id())
                          ->first();

        if (!$subTask) {
            return response()->json(['message' => 'Subtask tidak ditemukan.'], 404);
        }

        $subTask->delete();
        return response()->json(['message' => 'Subtask berhasil dihapus.']);
    }
}
