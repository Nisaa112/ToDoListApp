<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Todo extends Model
{
    // Todo.php
    protected $fillable = [
        'title',
        'user_id',
        'category_id',
        'due_date',
        'label_id',
        'date',
        'is_checked',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function subTasks()
    {
        return $this->hasMany(SubTask::class);
    }

    public function label()
    {
        return $this->belongsTo(Label::class);
    }



    // public function user()
    // {
    //     return $this->belongsTo(User::class, 'id_users');
    // }
}
