<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LampiranPikiran extends Model
{
    use HasFactory;

    protected $table = 'lampiran_pikiran';

    protected $fillable = [
        'user_id', 
        'catatan_pikiran_id',
        'file_path',
        'file_type'
    ];

    public function catatanPikiran()
    {
        return $this->belongsTo(CatatanPikiran::class);
    }
}
