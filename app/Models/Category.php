<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Category extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';
    protected $fillable = ['name'];
    
    public function todo()
    {
        return $this->hasMany(Todo::class);
    }
}
