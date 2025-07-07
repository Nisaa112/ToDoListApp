<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubTask extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'todo_id',
        'title',
        'is_done',
    ];

    public function todo()
    {
        return $this->belongsTo(Todo::class);
    }
    public function user()
{
    return $this->belongsTo(User::class);
}


    
    
}
