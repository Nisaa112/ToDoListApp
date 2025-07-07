<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

    public function up()
    {
        Schema::table('todos', function (Blueprint $table) {
            $table->dateTime('date')->nullable()->after('title');
            $table->boolean('is_checked')->default(false)->after('date');
        });
    }


    public function down()
    {
        Schema::table('todos', function (Blueprint $table) {
            $table->dropColumn('date');
            $table->dropColumn('is_checked');
        });
    }
};
