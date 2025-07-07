<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('lampiran_pikiran', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('catatan_pikiran_id');
            $table->string('file_path');
            $table->string('file_type')->nullable();
            $table->timestamps();

            $table->foreign('catatan_pikiran_id')
                ->references('id')
                ->on('catatan_pikiran')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lampiran_pikiran');
    }
};
