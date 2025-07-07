<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('lampiran', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('todo_id');
            $table->string('file_path'); // lokasi file disimpan di storage
            $table->string('file_type')->nullable(); // tipe file (gambar/pdf/dll)
            $table->timestamps();

            // Foreign key ke tabel todos
            $table->foreign('todo_id')->references('id')->on('todos')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lampiran');
    }
};
