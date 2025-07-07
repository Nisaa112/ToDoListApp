<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Todo;

class TodoController extends Controller
{
    // GET /api/todos
    public function index()
    {
        $todos = Todo::all();
        return response()->json($todos);
    }

    // GET /api/todos/{id}
    public function show($id)
    {
        $todo = Todo::find($id);
        if (!$todo) {
            return response()->json(['message' => 'Todo not found'], 404);
        }
        return response()->json($todo);
    }

    // POST /api/todos
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'title' => 'required|string',
            'label_id' => 'nullable|exists:labels,id',
            'due_date' => 'nullable|date', 
            'date' => 'required|date', 
            'is_checked' => 'boolean', 
        ]);


        $todo = Todo::create($validated);
        return response()->json($todo, 201);
    }


    // PUT /api/todos/{id}
    public function update(Request $request, $id)
    {
        $todo = Todo::find($id);
        if (!$todo) {
            return response()->json(['message' => 'Todo not found'], 404);
        }

        $validated = $request->validate([
            'user_id' => 'sometimes|required|exists:users,id',
            'category_id' => 'sometimes|required|exists:categories,id',
            'title' => 'sometimes|required|string',
            'label_id' => 'nullable|exists:labels,id',
            'due_date' => 'nullable|date',
            'date' => 'sometimes|required|date', 
            'is_checked' => 'boolean', 

        ]);

        $todo->update($validated);
        return response()->json($todo);
    }


    // DELETE /api/todos/{id}
    public function destroy($id)
    {
        $todo = Todo::find($id);
        if (!$todo) {
            return response()->json(['message' => 'Todo not found'], 404);
        }

        $todo->delete();
        return response()->json(['message' => 'Todo deleted']);
    }
}
