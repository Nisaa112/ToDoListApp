<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\TodoController;
use App\Http\Controllers\Api\NotesController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\AuthSerialNumberController;
use App\Http\Controllers\SubTaskController;
use App\Http\Controllers\Api\TaskNoteController;
use App\Http\Controllers\Api\TaskRepeatController;
use App\Http\Controllers\LabelController;
use App\Http\Controllers\Api\LampiranController;
use App\Http\Controllers\Api\CatatanPikiranController;
use App\Http\Controllers\Api\LampiranPikiranController;
use App\Http\Controllers\Api\AuthSerialLoginController;
use App\Http\Controllers\Api\CategoriUserController;
use App\Http\Controllers\DifficultyController;

// =======================
// 🔓 Route Web (bisa diakses via browser)
// =======================

Route::get('/', function () {
    return view('welcome'); // default route
});

Route::get('/admin/user/create', function () {
    return view('user_page.create'); // Pastikan folder = user_page (tanpa spasi)
});

// =======================
// 🔓 Route API (Tanpa Auth Middleware)
// =======================

Route::post('/login', [AuthSerialLoginController::class, 'login'])->name('login');
Route::post('/tambah-serial', [AuthSerialNumberController::class, 'store']);

// =======================
// 🔐 Route API (Dengan Auth JWT)
// =======================
Route::middleware('auth:api')->group(function () {
    Route::apiResource('todos', TodoController::class);
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('notes', NotesController::class);
    Route::apiResource('users', UserController::class);
    Route::apiResource('auth-serial-numbers', AuthSerialLoginController::class);
    Route::apiResource('sub-tasks', SubTaskController::class);
    Route::apiResource('task-notes', TaskNoteController::class);
    Route::apiResource('task-repeats', TaskRepeatController::class);
    Route::apiResource('lampiran', LampiranController::class);
    Route::apiResource('catatan-pikiran', CatatanPikiranController::class);
    Route::apiResource('categori-user', CategoriUserController::class);
    Route::apiResource('difficulties', DifficultyController::class);
    Route::apiResource('labels', LabelController::class);
    Route::apiResource('lampiran-pikiran', LampiranPikiranController::class);

    Route::get('/me', function () {
        return response()->json(auth('api')->user());
    });

    Route::post('/user/photo', [UserController::class, 'updatePhoto']);
});
