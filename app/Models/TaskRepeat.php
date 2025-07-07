<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TaskRepeat extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'todo_id',
        'repeat_type',
        'interval_days',
        'start_date',
        'end_date',
    ];

    public function todo()
    {
        return $this->belongsTo(Todo::class);
    }
}
