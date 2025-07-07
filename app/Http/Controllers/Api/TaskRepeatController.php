<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TaskRepeat;

class TaskRepeatController extends Controller
{
    public function index()
    {
        return response()->json(TaskRepeat::all(), 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'todo_id' => 'required|exists:todos,id',
            'repeat_type' => 'required|in:daily,weekly,monthly',
            'interval_days' => 'required|integer|min:1',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
        ]);

        $data = TaskRepeat::create($request->all());

        return response()->json([
            'message' => 'Task Repeat berhasil ditambahkan.',
            'data' => $data
        ], 201);
    }

    public function show($id)
    {
        $repeat = TaskRepeat::find($id);
        if (!$repeat) {
            return response()->json(['message' => 'Task Repeat tidak ditemukan.'], 404);
        }

        return response()->json($repeat, 200);
    }

    public function update(Request $request, $id)
    {
        $repeat = TaskRepeat::find($id);
        if (!$repeat) {
            return response()->json(['message' => 'Task Repeat tidak ditemukan.'], 404);
        }

        $request->validate([
            'repeat_type' => 'in:daily,weekly,monthly',
            'interval_days' => 'integer|min:1',
            'start_date' => 'date',
            'end_date' => 'date|after_or_equal:start_date',
        ]);

        $repeat->update($request->all());

        return response()->json([
            'message' => 'Task Repeat berhasil diperbarui.',
            'data' => $repeat
        ]);
    }


    public function destroy($id)
    {
        $repeat = TaskRepeat::find($id);
        if (!$repeat) {
            return response()->json(['message' => 'Task Repeat tidak ditemukan.'], 404);
        }

        $repeat->delete();

        return response()->json(['message' => 'Task Repeat berhasil dihapus.'], 200);
    }
}
