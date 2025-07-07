<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TaskNote extends Model
{
    use HasFactory;

    protected $fillable = ['todo_id', 'note', 'user_id'];

    public function todo()
    {
        return $this->belongsTo(Todo::class);
    }
}
