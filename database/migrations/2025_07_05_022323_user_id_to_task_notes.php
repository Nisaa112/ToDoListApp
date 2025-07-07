<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('task_notes', function (Blueprint $table) {
            // Tambahkan kolom user_id
            $table->unsignedBigInteger('user_id')->after('id');

            // Tambahkan foreign key-nya
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::table('task_notes', function (Blueprint $table) {
            // Hapus foreign key dulu
            $table->dropForeign(['user_id']);

            // Baru hapus kolomnya
            $table->dropColumn('user_id');
        });
    }
};
