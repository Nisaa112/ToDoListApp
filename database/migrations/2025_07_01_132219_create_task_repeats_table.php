<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('task_repeats', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('todo_id');
            $table->enum('repeat_type', ['daily', 'weekly', 'monthly'])->default('daily');
            $table->integer('interval_days')->default(1);
            $table->date('start_date')->nullable();
            $table->date('end_date')->nullable();
            $table->timestamps();

            $table->foreign('todo_id')->references('id')->on('todos')->onDelete('cascade');
        });
    }


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('task_repeats');
    }
};
