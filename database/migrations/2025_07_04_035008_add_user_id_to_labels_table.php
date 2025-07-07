<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration 
{
    public function up()
    {
        Schema::table('labels', function (Blueprint $table) {
            // Tambahkan foreign key ke tabel users
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::table('labels', function (Blueprint $table) {
            // Hapus foreign key jika rollback
            $table->dropForeign(['user_id']);
        });
    }
};
