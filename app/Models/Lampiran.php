<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Lampiran extends Model
{
    protected $table = 'lampiran';

    protected $fillable = [
        'todo_id',
        'file_path',
        'user_id',
        'file_type'
    ];

    public function todo()
    {
        return $this->belongsTo(Todo::class);
    }
}
