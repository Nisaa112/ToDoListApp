<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddUserIdToCategoriesTable extends Migration
{
    public function up()
    {
        Schema::table('categories', function (Blueprint $table) {
            // Kolom user_id sudah ada, jadi cukup tambahkan foreign key-nya saja
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::table('categories', function (Blueprint $table) {
            // Hapus foreign key, tapi jangan hapus kolomnya karena sudah ada
            $table->dropForeign(['user_id']);
        });
    }
}
