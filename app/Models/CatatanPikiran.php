<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CatatanPikiran extends Model
{
    use HasFactory;

    protected $table = 'catatan_pikiran';

    protected $fillable = [
        'user_id',
        'judul',
        'isi',
    ];

    public function lampiran()
    {
        return $this->hasMany(LampiranPikiran::class);
    }
}
