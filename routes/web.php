<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Web\UserWebController;
use App\Http\Controllers\Web\AuthSerialNumberWebController;



Route::get('/admin/user/create', [UserWebController::class, 'create'])->name('user.create');
Route::post('/admin/user/store', [UserWebController::class, 'store'])->name('user.store');
Route::post('/admin/user/save', [UserWebController::class, 'store']);


// Serial Number Routes
Route::prefix('admin/serial')->group(function () {
    Route::get('/create', [AuthSerialNumberWebController::class, 'create'])->name('serial.create');
    Route::post('/store', [AuthSerialNumberWebController::class, 'store'])->name('serial.store');
});