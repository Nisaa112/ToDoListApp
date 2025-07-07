<?php

namespace App\Http\Controllers;

use App\Models\Difficulty;
use Illuminate\Http\Request;

class DifficultyController extends Controller
{
    // GET all
    public function index()
    {
        return response()->json(Difficulty::all());
    }

    // GET single
    public function show($id)
    {
        $difficulty = Difficulty::find($id);
        if (!$difficulty) {
            return response()->json(['message' => 'Not found'], 404);
        }
        return response()->json($difficulty);
    }

    // POST (Create)
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $difficulty = Difficulty::create([
            'name' => $request->name,
        ]);

        return response()->json($difficulty, 201);
    }

    // PUT (Update)
    public function update(Request $request, $id)
    {
        $difficulty = Difficulty::find($id);
        if (!$difficulty) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $difficulty->update([
            'name' => $request->name,
        ]);

        return response()->json($difficulty);
    }

    // DELETE
    public function destroy($id)
    {
        $difficulty = Difficulty::find($id);
        if (!$difficulty) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $difficulty->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
